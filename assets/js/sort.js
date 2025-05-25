const siblingIndex = (node) => {
  let count = 0;
  while (node = node.previousElementSibling) {
    count++;
  }
  return count;
},
sortDateVal = (a, b) => {
  const dA = Date.parse(a.value),
    dB = Date.parse(b.value);
  return sortNumber(dA, dB);
},
sortNumber = (a, b) => {
  return a - b;
},
sortNumberVal = (a, b) => {
  return a.value - b.value;
},
sortRows = (table, columnIdx) => {
  let rows = table.querySelectorAll("tbody tr"),
    sel = `td:nth-child(${columnIdx+1})`,
    selType = `thead th:nth-child(${columnIdx+1})`,
    classList = table.querySelector(selType).classList,
    values = [],
    cls = "";

  if (classList) {
    if (classList.contains("date")) {
      cls = "date";
    } else if (classList.contains("number")) {
      cls = "number";
    }
  }

  for (let index = 0; index < rows.length; index++) {
    const node = rows[index].querySelector(sel),
      val = node.querySelector("span.sorter");
    if (cls == "number") {
      values.push({ value: parseInt(val.dataset.sortValue), row: rows[index] });
    } else {
      values.push({ value: val.dataset.sortValue, row: rows[index] });
    }
  }

  if (cls == "date") {
    values.sort(sortDateVal);
  } else if (cls == "number") {
    values.sort(sortNumberVal);
  } else {
    values.sort(sortTextVal);
  }

  for (let idx = 0; idx < values.length; idx++) {
    table.querySelector("tbody").appendChild(values[idx].row);
  }
},
sortTable = (table) => {
  return function(ev) {
    if (ev.target.tagName.toLowerCase() == 'a') {
      sortRows(table, siblingIndex(ev.target.parentNode));
      ev.preventDefault();
    }
  };
},
sortTextVal = (a, b) => {
  const tA = (a.value + '').toUpperCase(),
    tB = (b.value + '').toUpperCase();
  if (tA < tB) {
    return -1;
  } else if (tA > tB) {
    return 1;
  }
  return 0;
};

export default Sort = {
  setup: () => {
    var tables = document.querySelectorAll("table.sortable");
    for (i = 0; i < tables.length; i++) {
      const table = tables[i];

      if (thead = table.querySelector("thead")) {
        const headers = thead.querySelectorAll("th");

        for (let j = 0; j < headers.length; j++) {
          if (headers[j].querySelector("span.sortable")) {
            headers[j].innerHTML = `<a class="font-semibold" href="#">${headers[j].innerText}</a>`;
          } else {
            headers[j].innerHTML = `<span class="font-normal text-yellow-600">${headers[j].innerText}</span>`;
          }
        }
        thead.addEventListener("click", sortTable(table));
      }
    }
  },
};
