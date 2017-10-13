

```python
import os
import csv
import pandas as pd
import numpy as np
```


```python
#set csv paths
schoolpath = os.path.join("Resources", "schools_complete.csv")
studentpath = os.path.join("Resources", "students_complete.csv")
school_data = pd.read_csv(schoolpath)
student_data = pd.read_csv(studentpath)
merged_data = pd.merge(school_data, student_data, on='school')
merged_data.head()
```




<div>
<style>
    .dataframe thead tr:only-child th {
        text-align: right;
    }

    .dataframe thead th {
        text-align: left;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>School ID</th>
      <th>school</th>
      <th>type</th>
      <th>size</th>
      <th>budget</th>
      <th>Student ID</th>
      <th>name</th>
      <th>gender</th>
      <th>grade</th>
      <th>reading_score</th>
      <th>math_score</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>0</td>
      <td>Huang High School</td>
      <td>District</td>
      <td>2917</td>
      <td>1910635</td>
      <td>0</td>
      <td>Paul Bradley</td>
      <td>M</td>
      <td>9th</td>
      <td>66</td>
      <td>79</td>
    </tr>
    <tr>
      <th>1</th>
      <td>0</td>
      <td>Huang High School</td>
      <td>District</td>
      <td>2917</td>
      <td>1910635</td>
      <td>1</td>
      <td>Victor Smith</td>
      <td>M</td>
      <td>12th</td>
      <td>94</td>
      <td>61</td>
    </tr>
    <tr>
      <th>2</th>
      <td>0</td>
      <td>Huang High School</td>
      <td>District</td>
      <td>2917</td>
      <td>1910635</td>
      <td>2</td>
      <td>Kevin Rodriguez</td>
      <td>M</td>
      <td>12th</td>
      <td>90</td>
      <td>60</td>
    </tr>
    <tr>
      <th>3</th>
      <td>0</td>
      <td>Huang High School</td>
      <td>District</td>
      <td>2917</td>
      <td>1910635</td>
      <td>3</td>
      <td>Dr. Richard Scott</td>
      <td>M</td>
      <td>12th</td>
      <td>67</td>
      <td>58</td>
    </tr>
    <tr>
      <th>4</th>
      <td>0</td>
      <td>Huang High School</td>
      <td>District</td>
      <td>2917</td>
      <td>1910635</td>
      <td>4</td>
      <td>Bonnie Ray</td>
      <td>F</td>
      <td>9th</td>
      <td>97</td>
      <td>84</td>
    </tr>
  </tbody>
</table>
</div>




```python
district_schools = school_data.school.nunique()
district_students = school_data['size'].sum()
district_budget = school_data.budget.sum()
average_math = student_data.math_score.mean()
average_read = student_data.reading_score.mean()

passing_math = student_data[student_data['math_score'] >= 70].count()
math_percent = passing_math.math_score / district_students
passing_reading = student_data[student_data['reading_score'] >= 70].count()
read_percent = passing_reading.reading_score / district_students
passing_overall = (math_percent + read_percent) / 2 


district_summary = [{'Total Schools': district_schools, 'Total Num of Students':district_students, 'Total Budget':district_budget,'Average Math Score': average_math, 'Average Reading Score' : average_read, 'Math Pass %' : math_percent, 'Reading Pass %': read_percent, 'Overall Pass %': passing_overall}]
district_df = pd.DataFrame(district_summary, columns = ['Total Schools', 'Total Num of Students','Total Budget','Average Math Score','Average Reading Score','Math Pass %','Reading Pass %','Overall Pass %'])
district_df
```




<div>
<style>
    .dataframe thead tr:only-child th {
        text-align: right;
    }

    .dataframe thead th {
        text-align: left;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Total Schools</th>
      <th>Total Num of Students</th>
      <th>Total Budget</th>
      <th>Average Math Score</th>
      <th>Average Reading Score</th>
      <th>Math Pass %</th>
      <th>Reading Pass %</th>
      <th>Overall Pass %</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>15</td>
      <td>39170</td>
      <td>24649428</td>
      <td>78.985371</td>
      <td>81.87784</td>
      <td>0.749809</td>
      <td>0.858055</td>
      <td>0.803932</td>
    </tr>
  </tbody>
</table>
</div>




```python
school_summary= merged_data.groupby('school').mean()
```


```python
school_students = merged_data.groupby('school')['size'].count()
school_type = merged_data.groupby('school').type
school_budget = school_data.groupby('school').budget.sum()
budget_per_student = school_budget / school_students
school_math_avg = merged_data.groupby('school').math_score.mean()
school_read_avg = merged_data.groupby('school').reading_score.mean()
school_passing_math = merged_data[merged_data.math_score >= 70].groupby('school').count()
school_math_percent = school_passing_math['math_score'] / school_students
school_passing_read = merged_data[merged_data.reading_score >= 70].groupby('school').count()
school_read_percent = school_passing_read['reading_score'] / school_students
school_overall = (school_math_percent + school_read_percent) / 2


```


```python
school_df = pd.concat((school_summary,budget_per_student),axis = 1, join='inner',)
school_df = pd.concat((school_df,school_math_percent),axis = 1, join='inner',)
school_df = pd.concat((school_df,school_read_percent),axis = 1, join='inner',)
school_df = pd.concat((school_df,school_overall),axis = 1, join='inner',)

school_df.columns = ['School_ID', 'Total Students', 'Total School Budget','Student ID', 'Average Reading Score', 'Average MathScore','Budget per Student','% Passing Math','% Passing Reading','% Overall Passing Rate']
school_df.drop('School_ID', axis=1, inplace=True)
school_df.drop('Student ID', axis=1, inplace=True)
school_df
```




<div>
<style>
    .dataframe thead tr:only-child th {
        text-align: right;
    }

    .dataframe thead th {
        text-align: left;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Total Students</th>
      <th>Total School Budget</th>
      <th>Average Reading Score</th>
      <th>Average MathScore</th>
      <th>Budget per Student</th>
      <th>% Passing Math</th>
      <th>% Passing Reading</th>
      <th>% Overall Passing Rate</th>
    </tr>
    <tr>
      <th>school</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Bailey High School</th>
      <td>4976.0</td>
      <td>3124928.0</td>
      <td>81.033963</td>
      <td>77.048432</td>
      <td>628.0</td>
      <td>0.666801</td>
      <td>0.819333</td>
      <td>0.743067</td>
    </tr>
    <tr>
      <th>Cabrera High School</th>
      <td>1858.0</td>
      <td>1081356.0</td>
      <td>83.975780</td>
      <td>83.061895</td>
      <td>582.0</td>
      <td>0.941335</td>
      <td>0.970398</td>
      <td>0.955867</td>
    </tr>
    <tr>
      <th>Figueroa High School</th>
      <td>2949.0</td>
      <td>1884411.0</td>
      <td>81.158020</td>
      <td>76.711767</td>
      <td>639.0</td>
      <td>0.659885</td>
      <td>0.807392</td>
      <td>0.733639</td>
    </tr>
    <tr>
      <th>Ford High School</th>
      <td>2739.0</td>
      <td>1763916.0</td>
      <td>80.746258</td>
      <td>77.102592</td>
      <td>644.0</td>
      <td>0.683096</td>
      <td>0.792990</td>
      <td>0.738043</td>
    </tr>
    <tr>
      <th>Griffin High School</th>
      <td>1468.0</td>
      <td>917500.0</td>
      <td>83.816757</td>
      <td>83.351499</td>
      <td>625.0</td>
      <td>0.933924</td>
      <td>0.971390</td>
      <td>0.952657</td>
    </tr>
    <tr>
      <th>Hernandez High School</th>
      <td>4635.0</td>
      <td>3022020.0</td>
      <td>80.934412</td>
      <td>77.289752</td>
      <td>652.0</td>
      <td>0.667530</td>
      <td>0.808630</td>
      <td>0.738080</td>
    </tr>
    <tr>
      <th>Holden High School</th>
      <td>427.0</td>
      <td>248087.0</td>
      <td>83.814988</td>
      <td>83.803279</td>
      <td>581.0</td>
      <td>0.925059</td>
      <td>0.962529</td>
      <td>0.943794</td>
    </tr>
    <tr>
      <th>Huang High School</th>
      <td>2917.0</td>
      <td>1910635.0</td>
      <td>81.182722</td>
      <td>76.629414</td>
      <td>655.0</td>
      <td>0.656839</td>
      <td>0.813164</td>
      <td>0.735002</td>
    </tr>
    <tr>
      <th>Johnson High School</th>
      <td>4761.0</td>
      <td>3094650.0</td>
      <td>80.966394</td>
      <td>77.072464</td>
      <td>650.0</td>
      <td>0.660576</td>
      <td>0.812224</td>
      <td>0.736400</td>
    </tr>
    <tr>
      <th>Pena High School</th>
      <td>962.0</td>
      <td>585858.0</td>
      <td>84.044699</td>
      <td>83.839917</td>
      <td>609.0</td>
      <td>0.945946</td>
      <td>0.959459</td>
      <td>0.952703</td>
    </tr>
    <tr>
      <th>Rodriguez High School</th>
      <td>3999.0</td>
      <td>2547363.0</td>
      <td>80.744686</td>
      <td>76.842711</td>
      <td>637.0</td>
      <td>0.663666</td>
      <td>0.802201</td>
      <td>0.732933</td>
    </tr>
    <tr>
      <th>Shelton High School</th>
      <td>1761.0</td>
      <td>1056600.0</td>
      <td>83.725724</td>
      <td>83.359455</td>
      <td>600.0</td>
      <td>0.938671</td>
      <td>0.958546</td>
      <td>0.948609</td>
    </tr>
    <tr>
      <th>Thomas High School</th>
      <td>1635.0</td>
      <td>1043130.0</td>
      <td>83.848930</td>
      <td>83.418349</td>
      <td>638.0</td>
      <td>0.932722</td>
      <td>0.973089</td>
      <td>0.952905</td>
    </tr>
    <tr>
      <th>Wilson High School</th>
      <td>2283.0</td>
      <td>1319574.0</td>
      <td>83.989488</td>
      <td>83.274201</td>
      <td>578.0</td>
      <td>0.938677</td>
      <td>0.965396</td>
      <td>0.952037</td>
    </tr>
    <tr>
      <th>Wright High School</th>
      <td>1800.0</td>
      <td>1049400.0</td>
      <td>83.955000</td>
      <td>83.682222</td>
      <td>583.0</td>
      <td>0.933333</td>
      <td>0.966111</td>
      <td>0.949722</td>
    </tr>
  </tbody>
</table>
</div>




```python
topschools = school_df.sort_values('% Overall Passing Rate', ascending = False)
topschools = topschools[:5]
topschools
```




<div>
<style>
    .dataframe thead tr:only-child th {
        text-align: right;
    }

    .dataframe thead th {
        text-align: left;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Total Students</th>
      <th>Total School Budget</th>
      <th>Average Reading Score</th>
      <th>Average MathScore</th>
      <th>Budget per Student</th>
      <th>% Passing Math</th>
      <th>% Passing Reading</th>
      <th>% Overall Passing Rate</th>
    </tr>
    <tr>
      <th>school</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Cabrera High School</th>
      <td>1858.0</td>
      <td>1081356.0</td>
      <td>83.975780</td>
      <td>83.061895</td>
      <td>582.0</td>
      <td>0.941335</td>
      <td>0.970398</td>
      <td>0.955867</td>
    </tr>
    <tr>
      <th>Thomas High School</th>
      <td>1635.0</td>
      <td>1043130.0</td>
      <td>83.848930</td>
      <td>83.418349</td>
      <td>638.0</td>
      <td>0.932722</td>
      <td>0.973089</td>
      <td>0.952905</td>
    </tr>
    <tr>
      <th>Pena High School</th>
      <td>962.0</td>
      <td>585858.0</td>
      <td>84.044699</td>
      <td>83.839917</td>
      <td>609.0</td>
      <td>0.945946</td>
      <td>0.959459</td>
      <td>0.952703</td>
    </tr>
    <tr>
      <th>Griffin High School</th>
      <td>1468.0</td>
      <td>917500.0</td>
      <td>83.816757</td>
      <td>83.351499</td>
      <td>625.0</td>
      <td>0.933924</td>
      <td>0.971390</td>
      <td>0.952657</td>
    </tr>
    <tr>
      <th>Wilson High School</th>
      <td>2283.0</td>
      <td>1319574.0</td>
      <td>83.989488</td>
      <td>83.274201</td>
      <td>578.0</td>
      <td>0.938677</td>
      <td>0.965396</td>
      <td>0.952037</td>
    </tr>
  </tbody>
</table>
</div>




```python
bottomschools =school_df.sort_values('% Overall Passing Rate')
bottomschools = bottomschools[:5]
bottomschools
```




<div>
<style>
    .dataframe thead tr:only-child th {
        text-align: right;
    }

    .dataframe thead th {
        text-align: left;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Total Students</th>
      <th>Total School Budget</th>
      <th>Average Reading Score</th>
      <th>Average MathScore</th>
      <th>Budget per Student</th>
      <th>% Passing Math</th>
      <th>% Passing Reading</th>
      <th>% Overall Passing Rate</th>
    </tr>
    <tr>
      <th>school</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Rodriguez High School</th>
      <td>3999.0</td>
      <td>2547363.0</td>
      <td>80.744686</td>
      <td>76.842711</td>
      <td>637.0</td>
      <td>0.663666</td>
      <td>0.802201</td>
      <td>0.732933</td>
    </tr>
    <tr>
      <th>Figueroa High School</th>
      <td>2949.0</td>
      <td>1884411.0</td>
      <td>81.158020</td>
      <td>76.711767</td>
      <td>639.0</td>
      <td>0.659885</td>
      <td>0.807392</td>
      <td>0.733639</td>
    </tr>
    <tr>
      <th>Huang High School</th>
      <td>2917.0</td>
      <td>1910635.0</td>
      <td>81.182722</td>
      <td>76.629414</td>
      <td>655.0</td>
      <td>0.656839</td>
      <td>0.813164</td>
      <td>0.735002</td>
    </tr>
    <tr>
      <th>Johnson High School</th>
      <td>4761.0</td>
      <td>3094650.0</td>
      <td>80.966394</td>
      <td>77.072464</td>
      <td>650.0</td>
      <td>0.660576</td>
      <td>0.812224</td>
      <td>0.736400</td>
    </tr>
    <tr>
      <th>Ford High School</th>
      <td>2739.0</td>
      <td>1763916.0</td>
      <td>80.746258</td>
      <td>77.102592</td>
      <td>644.0</td>
      <td>0.683096</td>
      <td>0.792990</td>
      <td>0.738043</td>
    </tr>
  </tbody>
</table>
</div>




```python
school_summary.columns
```




    Index(['School ID', 'size', 'budget', 'Student ID', 'reading_score',
           'math_score'],
          dtype='object')




```python
math_score = merged_data[['school', 'grade', 'math_score']]
math_score =math_score.groupby(['school','grade'])['math_score'].mean()
math_score = math_score.reset_index().pivot(index ='school',columns='grade',values = 'math_score')
cols=math_score.columns.tolist()
cols=cols[-1:]+cols[:-1]
math_score=math_score[cols]
math_score
```




<div>
<style>
    .dataframe thead tr:only-child th {
        text-align: right;
    }

    .dataframe thead th {
        text-align: left;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th>grade</th>
      <th>9th</th>
      <th>10th</th>
      <th>11th</th>
      <th>12th</th>
    </tr>
    <tr>
      <th>school</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Bailey High School</th>
      <td>77.083676</td>
      <td>76.996772</td>
      <td>77.515588</td>
      <td>76.492218</td>
    </tr>
    <tr>
      <th>Cabrera High School</th>
      <td>83.094697</td>
      <td>83.154506</td>
      <td>82.765560</td>
      <td>83.277487</td>
    </tr>
    <tr>
      <th>Figueroa High School</th>
      <td>76.403037</td>
      <td>76.539974</td>
      <td>76.884344</td>
      <td>77.151369</td>
    </tr>
    <tr>
      <th>Ford High School</th>
      <td>77.361345</td>
      <td>77.672316</td>
      <td>76.918058</td>
      <td>76.179963</td>
    </tr>
    <tr>
      <th>Griffin High School</th>
      <td>82.044010</td>
      <td>84.229064</td>
      <td>83.842105</td>
      <td>83.356164</td>
    </tr>
    <tr>
      <th>Hernandez High School</th>
      <td>77.438495</td>
      <td>77.337408</td>
      <td>77.136029</td>
      <td>77.186567</td>
    </tr>
    <tr>
      <th>Holden High School</th>
      <td>83.787402</td>
      <td>83.429825</td>
      <td>85.000000</td>
      <td>82.855422</td>
    </tr>
    <tr>
      <th>Huang High School</th>
      <td>77.027251</td>
      <td>75.908735</td>
      <td>76.446602</td>
      <td>77.225641</td>
    </tr>
    <tr>
      <th>Johnson High School</th>
      <td>77.187857</td>
      <td>76.691117</td>
      <td>77.491653</td>
      <td>76.863248</td>
    </tr>
    <tr>
      <th>Pena High School</th>
      <td>83.625455</td>
      <td>83.372000</td>
      <td>84.328125</td>
      <td>84.121547</td>
    </tr>
    <tr>
      <th>Rodriguez High School</th>
      <td>76.859966</td>
      <td>76.612500</td>
      <td>76.395626</td>
      <td>77.690748</td>
    </tr>
    <tr>
      <th>Shelton High School</th>
      <td>83.420755</td>
      <td>82.917411</td>
      <td>83.383495</td>
      <td>83.778976</td>
    </tr>
    <tr>
      <th>Thomas High School</th>
      <td>83.590022</td>
      <td>83.087886</td>
      <td>83.498795</td>
      <td>83.497041</td>
    </tr>
    <tr>
      <th>Wilson High School</th>
      <td>83.085578</td>
      <td>83.724422</td>
      <td>83.195326</td>
      <td>83.035794</td>
    </tr>
    <tr>
      <th>Wright High School</th>
      <td>83.264706</td>
      <td>84.010288</td>
      <td>83.836782</td>
      <td>83.644986</td>
    </tr>
  </tbody>
</table>
</div>




```python
reading_score = merged_data[['school', 'grade', 'reading_score']]
reading_score =reading_score.groupby(['school','grade'])['reading_score'].mean()
reading_score = reading_score.reset_index().pivot(index ='school',columns='grade',values = 'reading_score')
colsr=reading_score.columns.tolist()
colsr=colsr[-1:]+colsr[:-1]
reading_score=reading_score[cols]
reading_score
```




<div>
<style>
    .dataframe thead tr:only-child th {
        text-align: right;
    }

    .dataframe thead th {
        text-align: left;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th>grade</th>
      <th>9th</th>
      <th>10th</th>
      <th>11th</th>
      <th>12th</th>
    </tr>
    <tr>
      <th>school</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Bailey High School</th>
      <td>81.303155</td>
      <td>80.907183</td>
      <td>80.945643</td>
      <td>80.912451</td>
    </tr>
    <tr>
      <th>Cabrera High School</th>
      <td>83.676136</td>
      <td>84.253219</td>
      <td>83.788382</td>
      <td>84.287958</td>
    </tr>
    <tr>
      <th>Figueroa High School</th>
      <td>81.198598</td>
      <td>81.408912</td>
      <td>80.640339</td>
      <td>81.384863</td>
    </tr>
    <tr>
      <th>Ford High School</th>
      <td>80.632653</td>
      <td>81.262712</td>
      <td>80.403642</td>
      <td>80.662338</td>
    </tr>
    <tr>
      <th>Griffin High School</th>
      <td>83.369193</td>
      <td>83.706897</td>
      <td>84.288089</td>
      <td>84.013699</td>
    </tr>
    <tr>
      <th>Hernandez High School</th>
      <td>80.866860</td>
      <td>80.660147</td>
      <td>81.396140</td>
      <td>80.857143</td>
    </tr>
    <tr>
      <th>Holden High School</th>
      <td>83.677165</td>
      <td>83.324561</td>
      <td>83.815534</td>
      <td>84.698795</td>
    </tr>
    <tr>
      <th>Huang High School</th>
      <td>81.290284</td>
      <td>81.512386</td>
      <td>81.417476</td>
      <td>80.305983</td>
    </tr>
    <tr>
      <th>Johnson High School</th>
      <td>81.260714</td>
      <td>80.773431</td>
      <td>80.616027</td>
      <td>81.227564</td>
    </tr>
    <tr>
      <th>Pena High School</th>
      <td>83.807273</td>
      <td>83.612000</td>
      <td>84.335938</td>
      <td>84.591160</td>
    </tr>
    <tr>
      <th>Rodriguez High School</th>
      <td>80.993127</td>
      <td>80.629808</td>
      <td>80.864811</td>
      <td>80.376426</td>
    </tr>
    <tr>
      <th>Shelton High School</th>
      <td>84.122642</td>
      <td>83.441964</td>
      <td>84.373786</td>
      <td>82.781671</td>
    </tr>
    <tr>
      <th>Thomas High School</th>
      <td>83.728850</td>
      <td>84.254157</td>
      <td>83.585542</td>
      <td>83.831361</td>
    </tr>
    <tr>
      <th>Wilson High School</th>
      <td>83.939778</td>
      <td>84.021452</td>
      <td>83.764608</td>
      <td>84.317673</td>
    </tr>
    <tr>
      <th>Wright High School</th>
      <td>83.833333</td>
      <td>83.812757</td>
      <td>84.156322</td>
      <td>84.073171</td>
    </tr>
  </tbody>
</table>
</div>




```python
bins = [0,580,600,620,640,660]
bin_labels = ['0 to $580','$580 to $600','$600 to $620', '$620 to $640', '$640 to $660']
pd.cut(school_df['Budget per Student'],bins,labels = bin_labels)
school_df['Spending Range Per Student'] = pd.cut(school_df['Budget per Student'],bins,labels = bin_labels)
spending_df =school_df.reset_index(drop=True)
spending_df= spending_df.groupby(['Spending Range Per Student']).mean()
spending_df= spending_df.drop('Total Students',1)
spending_df= spending_df.drop('Total School Budget',1)
spending_df= spending_df.drop('Budget per Student',1)
spending_df
```




<div>
<style>
    .dataframe thead tr:only-child th {
        text-align: right;
    }

    .dataframe thead th {
        text-align: left;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Average Reading Score</th>
      <th>Average MathScore</th>
      <th>% Passing Math</th>
      <th>% Passing Reading</th>
      <th>% Overall Passing Rate</th>
    </tr>
    <tr>
      <th>Spending Range Per Student</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0 to $580</th>
      <td>83.989488</td>
      <td>83.274201</td>
      <td>0.938677</td>
      <td>0.965396</td>
      <td>0.952037</td>
    </tr>
    <tr>
      <th>$580 to $600</th>
      <td>83.867873</td>
      <td>83.476713</td>
      <td>0.934599</td>
      <td>0.964396</td>
      <td>0.949498</td>
    </tr>
    <tr>
      <th>$600 to $620</th>
      <td>84.044699</td>
      <td>83.839917</td>
      <td>0.945946</td>
      <td>0.959459</td>
      <td>0.952703</td>
    </tr>
    <tr>
      <th>$620 to $640</th>
      <td>82.120471</td>
      <td>79.474551</td>
      <td>0.771399</td>
      <td>0.874681</td>
      <td>0.823040</td>
    </tr>
    <tr>
      <th>$640 to $660</th>
      <td>80.957446</td>
      <td>77.023555</td>
      <td>0.667010</td>
      <td>0.806752</td>
      <td>0.736881</td>
    </tr>
  </tbody>
</table>
</div>




```python
size_bins = (0,1000,2000,5000)
size_lables = ['Small(<1000)', 'Medium(1000-2000)', 'Large(2000-5000)']
pd.cut(school_df['Total Students'],size_bins,labels = size_lables)
school_df['School Size'] = pd.cut(school_df['Total Students'],size_bins,labels = size_lables)
school_size_df = school_df.reset_index(drop=True)
school_size_df = school_size_df.groupby(['School Size']).mean()
school_size_df= school_size_df.drop('Total Students',1)
school_size_df= school_size_df.drop('Total School Budget',1)
school_size_df= school_size_df.drop('Budget per Student',1)
school_size_df.head()
```




<div>
<style>
    .dataframe thead tr:only-child th {
        text-align: right;
    }

    .dataframe thead th {
        text-align: left;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Average Reading Score</th>
      <th>Average MathScore</th>
      <th>% Passing Math</th>
      <th>% Passing Reading</th>
      <th>% Overall Passing Rate</th>
    </tr>
    <tr>
      <th>School Size</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Small(&lt;1000)</th>
      <td>83.929843</td>
      <td>83.821598</td>
      <td>0.935502</td>
      <td>0.960994</td>
      <td>0.948248</td>
    </tr>
    <tr>
      <th>Medium(1000-2000)</th>
      <td>83.864438</td>
      <td>83.374684</td>
      <td>0.935997</td>
      <td>0.967907</td>
      <td>0.951952</td>
    </tr>
    <tr>
      <th>Large(2000-5000)</th>
      <td>81.344493</td>
      <td>77.746417</td>
      <td>0.699634</td>
      <td>0.827666</td>
      <td>0.763650</td>
    </tr>
  </tbody>
</table>
</div>




```python
type = school_data.type
school_type = school_df.reset_index(drop=True)
school_type['School Type'] = type
school_type = school_type.groupby('School Type').mean()
school_type= school_type.drop('Total School Budget',1)
school_type= school_type.drop('Total Students',1)
school_type= school_type.drop('Budget per Student',1)
school_type
```




<div>
<style>
    .dataframe thead tr:only-child th {
        text-align: right;
    }

    .dataframe thead th {
        text-align: left;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Average Reading Score</th>
      <th>Average MathScore</th>
      <th>% Passing Math</th>
      <th>% Passing Reading</th>
      <th>% Overall Passing Rate</th>
    </tr>
    <tr>
      <th>School Type</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Charter</th>
      <td>82.429369</td>
      <td>80.324201</td>
      <td>0.798740</td>
      <td>0.886242</td>
      <td>0.842491</td>
    </tr>
    <tr>
      <th>District</th>
      <td>82.643266</td>
      <td>80.556334</td>
      <td>0.822592</td>
      <td>0.898988</td>
      <td>0.860790</td>
    </tr>
  </tbody>
</table>
</div>


