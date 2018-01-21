var $tbody = document.querySelector("tbody");
var $timeInput = document.querySelector("#time");
var $searchBtn = document.querySelector("#search");

$searchBtn.addEventListener("click", handleSearchButtonClick);

var ufoData = dataSet;

function renderTable() {
	console.log($tbody)
	$tbody.innerHTML = "";
	console.log(ufoData.length)
	for ( var i=0; i < ufoData.length; i++) {
		var sighting = ufoData[i];
		var fields = Object.keys(sighting);
		var $row = $tbody.insertRow(i);
		for (var j = 0; j < fields.length; j++) {
			var field = fields[j];
			var $cell = $row.insertCell(j);
			$cell.innerText = sighting[field];
		}
	}
}

function handleSearchButtonClick() {
	var filterUfoData = $timeInput.value.trim().toLowerCase();
	if (filterUfoData === '') {
		ufoData = dataSet;
		renderTable();
		return;
	}

	ufoData = ufoData.filter(function(sighting){
		var ufoTime = sighting.datetime.toLowerCase();
		return ufoTime === filterUfoData;
	});
	renderTable();
}

renderTable();