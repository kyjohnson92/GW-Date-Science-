
var svgWidth = 1100;
var svgHeight = 800;

var margin = { top: 20, right: 40, bottom: 60, left: 100};

var width = svgWidth - margin.left - margin.right;
var height = svgHeight - margin.top - margin.bottom;

var svg = d3
	.select("body")
	.append("svg")
	.attr("width", svgWidth)
	.attr("height", svgHeight)
	.append("g")
	.attr("transform", "translate(" + margin.left + ","+ margin.top+ ")");

var xLinearScale = d3.scaleLinear().range([0,width]);
var yLinearScale = d3.scaleLinear().range([height,0]);

d3.csv("data.csv", function(error, healthData) {
	if (error) throw error;
	console.log(healthData);

	healthData.forEach(function(data) {
		data.healthcare = +data.healthcare;
		data.bachelors = +data.bachelors;

	});

	xLinearScale.domain([0, d3.max(healthData, function(data)	{
		return data.bachelors;
	})]);

	yLinearScale.domain([65, d3.max(healthData, function(data) {
		return data.healthcare;
	})]);

	var bottomAxis = d3.axisBottom(xLinearScale);
	var leftAxis = d3.axisLeft(yLinearScale);


  svg
	.selectAll("circle")
	.data(healthData)
	.enter()
	.append("circle")
    	.attr("cx", function(data) {
        	return xLinearScale(data.bachelors);
   		})
   		.attr("cy", function(data) {
        	return yLinearScale(data.healthcare);
   		})
      .attr("r", 10)
      .style("fill", "lightblue");


  svg.selectAll("text")
  	.data(healthData) 
  	.enter()
  	.append("text")
  		.attr("x", function(data) {
        	return xLinearScale(data.bachelors);
   		})
   		.attr("y", function(data) {
        	return yLinearScale(data.healthcare);
        })
  		.text( function(data){
  			return data.abbr
  		})
  		.attr("font-size", "10px")
  		.attr("text-anchor", "middle")
  		.attr("alignment-baseline", "middle")
  		.attr("fill", "white");

  	svg.append("text")
  		.attr("class" , "x label")
  		.attr("text-anchor", "middle")
  		.attr("x", width/2)
  		.attr("y", height+40)
  		.text("Percentage of POP with Bachelors Degree or Higher")

  	svg.append("text")
  		.attr("class" , "y label")
  		.attr("text-anchor", "end")
  		.attr("x", -130)
		.attr("y", -40 )
  		.attr("dy", ".75em")
  		.attr("transform", "rotate(-90)")
  		.text("Percentage of POP with Healthcare Coverage")

  svg.append("g").call(leftAxis);
  svg.append("g").attr("transform", "translate(0, " + height + ")").call(bottomAxis);
});