var dataset = [ ];
      for (var i=0; i<20; i++) {
        var newNumber = Math.round(Math.random() * 25);
        dataset.push(newNumber);
      }

      var w = 500;
      var h = 100;
      var barPadding = 1;

      var svg = d3.select("body")
      .append("svg")
      .attr("width", w)
      .attr("height", w);

      svg.selectAll("rect")
        .data(dataset)
        .enter()
        .append("rect")
        .attr("x", function(d, i){
          return i * (w/dataset.length);
        })
        .attr("y", function(d){
          return h -(d*4);
        })
        .attr("width", w/dataset.length - barPadding)
        .attr("height", function(d){
          return d*4;
        })
        .attr("fill",function(d){
          return "rgb(0," + (d*10) + ",0)";
        });