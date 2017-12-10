import datetime as dt
import numpy as np
import pandas as pd

import sqlalchemy
from sqlalchemy.ext.automap import automap_base
from sqlalchemy.orm import Session
from sqlalchemy import create_engine, func

from flask import Flask, jsonify



engine = create_engine('sqlite:///hawaii_sqlite.sqlite')
conn = engine.connect()
Base = automap_base()
Base.prepare(engine,reflect = True)
Base.metadata.create_all(conn)

Measurement = Base.classes.measurement_data
Station = Base.classes.station_data

session = Session(engine)

app = Flask(__name__)

@app.route('/')
def index():
	return (
		"Data Boot Camp Week 11 Homework:"
		f'<br/>'

	    f"Avalable Routes:<br/>"
		f"<br/>"
        f"/api/v1.0/precipitation<br/>"
		f"Amount of precipitation in the last year:<br/>"
		f"<br/>"        	
        f"/api/v1.0/stations<br/>"
        f"List of Hawaiian Weather Station:<br/>"
        f"<br/>"           						
        f"/api/v1.0/tobs<br/>"
		f"Recorded Temps for the last year:<br/>"
        f"<br/>"
        f"/api/v1.0/trip/&ltstart&gt<br/>"
		f"Historical Min, Max, and Avg Temps for after given date:<br/>"
        f"<br/>"
        f"/api/v1.0/trip/&ltstart&gt/&ltend&gt<br/>"
		f"Historical Min, Max, and Avg Temps during given dates:<br/>"
        f"<br/>"
    )


@app.route('/api/v1.0/precipitation')
def precipitation():
	results = session.query(Measurement.precipitation, Measurement.date).filter(Measurement.date.between('2016-08-24', '2017-08-23')).all()
	daily_temps =[]
	for result in results:
		row = {}
		row['date'] = results[1]
		row['precipitation'] = results[0]
		daily_temps.append(row)
	return jsonify(daily_temps)

@app.route('/api/v1.0/stations')
def stations():
	results = session.query(Station.station, Station.name)
	stations = []
	for station, name in results:
		stations.append(station)
	return jsonify(stations)


@app.route('/api/v1.0/tobs')
def tobs():
	tobs = []
	for row in session.query(Measurement.temperature, Measurement.date).filter(Measurement.date.between('2016-08-24', '2017-08-23')).all():
		tobs.append(row)
	return jsonify(tobs)


@app.route('/api/v1.0/trip/')
@app.route('/api/v1.0/trip/<start>')
def calc_temps(start = '2017-01-01'):
    trip_min = session.query(func.min(Measurement.temperature)).filter(Measurement.date >= start)
    trip_max = session.query(func.max(Measurement.temperature)).filter(Measurement.date >= start)
    trip_avg = session.query(func.avg(Measurement.temperature)).filter(Measurement.date >= start)
    result_min =[result[0] for result in trip_min]
    result_max =[result[0] for result in trip_max]   
    result_avg =[result[0] for result in trip_avg]
    your_temps = [result_min, result_max, result_avg]
    return jsonify(your_temps)


@app.route('/api/v1.0/trip/<start>/<end>')
def trip_temps(start = '2017-01-01', end= '2017-01-07'):
    trip_min = session.query(func.min(Measurement.temperature)).filter(Measurement.date.between(start , end))
    trip_max = session.query(func.max(Measurement.temperature)).filter(Measurement.date.between(start, end))
    trip_avg = session.query(func.avg(Measurement.temperature)).filter(Measurement.date.between(start , end))
    result_min =[result[0] for result in trip_min]
    result_max =[result[0] for result in trip_max]   
    result_avg =[result[0] for result in trip_avg]
    your_temps = [result_min, result_max, result_avg]
    return jsonify(your_temps)



if __name__ == '__main__':
    app.run()