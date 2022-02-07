document.addEventListener("DOMContentLoaded", () => {
  const selectDrop = document.querySelector("#countries");
  // const selectDrop = document.getElementById('countries');

  fetch("https://restcountries.com/v3.1/all")
    .then((res) => {
      return res.json();
    })
    .then((data) => {
      let output = "";
      data.forEach((country) => {
        output += `
        
        <option value="${country.name}">${country.name}</option>`;
      });

      selectDrop.innerHTML = output;
    })
    .catch((err) => {
      console.log(err);
    });
});

var gender = document.getElementById("gender"),
  arr = ["Male", "Female"];
for (var i = 0; i < arr.length; i++) {
  var option = document.createElement("OPTION"),
    txt = document.createTextNode(arr[i]);
  option.appendChild(txt);
  gender.insertBefore(option, gender.lastChild);
}
