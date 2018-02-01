import pandas as pd
import numpy as np

import sqlalchemy
from sqlalchemy.ext.automap import automap_base
from sqlalchemy.orm import Session
from sqlalchemy import create_engine, func
from sqlalchemy import create_engine, inspect , desc, distinct, func, extract, and_

from flask import Flask, jsonify, render_template, send_from_directory

engine = create_engine('sqlite:///datasets/belly_button_biodiversity.sqlite')
conn = engine.connect()
Base = automap_base()
Base.prepare(engine,reflect = True)
Base.metadata.create_all(conn)
otu = Base.classes.otu
meta = Base.classes.samples_metadata

session = Session(engine)
inspector = inspect(engine)

app = Flask(__name__)

@app.route("/")
def index():
    return render_template("index.html")

@app.route("/js/<filename>")
def downloadjs(filename):
    return send_from_directory("js", filename)

@app.route("/names")
def names():
    samples_col = inspector.get_columns('samples')
    samples = []
    for column in samples_col:
        samples.append(column['name'])
    return jsonify(samples)

@app.route("/otu")
def otu_route():
    otu_list = []
    for row in session.query(otu.lowest_taxonomic_unit_found):
        otu_list.append(row[0])
    return jsonify(otu_list)

@app.route("/metadata/<sample>")
def metaSample(sample):
    id = sample[3:]
    results = session.query(meta.SAMPLEID,meta.ETHNICITY,meta.GENDER, meta.AGE, meta.LOCATION, meta.BBTYPE).filter(meta.SAMPLEID == id)
    sample_metadata = {}
    for result in results:
        sample_metadata['SAMPLEID'] = result[0]
        sample_metadata['ETHNICITY'] = result[1]
        sample_metadata['GENDER'] = result[2]
        sample_metadata['AGE'] = result[3]
        sample_metadata['LOCATION'] = result[4]
        sample_metadata['BBTYPE'] = result[5]
    return jsonify(sample_metadata)

@app.route("/wfreq/<sample>")
def wfreq(sample):
    id = sample[3:]
    results = session.query(meta.WFREQ).filter(meta.SAMPLEID == id)
    return jsonify(results[0])    

@app.route("/samples/<sample>")
def sampledf(sample):
    Sample = Base.classes.samples
    results = "select * from samples"
    sample_df = pd.read_sql(results, engine)
    samp = sample_df[sample_df[sample] > 0]
    otu_id = samp['otu_id'].sort_values(ascending=False).tolist()
    samp_list = samp[sample].tolist() #.sort_values(ascending=False).
    d = {'otu_id': otu_id, 'sample_values':samp_list}
    return jsonify([d])

if __name__ == "__main__":
	app.run()