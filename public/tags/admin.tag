<admin>
  <div class="memeMaker">
    <input type="text" ref="urlEl" placeholder="Enter url">
    <input type="text" ref="captionEl" placeholder="Enter caption">
    <input type="text" ref="funnyEl" placeholder="Enter funness (0 to 5)">
    <button type="button" onclick={ saveMeme }>Add Meme</button>
  </div>

  <div class="order">
    <p>order data by</p>
    <select ref="order" value="" onchange={ orderResults }>
      <option value="default">default</option>
      <option value="funnees">funnees</option>
      <option value="caption">caption</option>
    </select>
  </div>


  <div class="filter">
    <p>filter by level of fun</p>
    <select ref="fun" value="" onchange={ filterResults }>
      <option value="default">Default</option>
      <option value="nofun">No Fun</option>
      <option value="somewhatfun">Some Fun</option>
      <option value="veryfun">Very Fun</option>
    </select>
  </div>

  <div show={ myMemes.length == 0 }>
    <p>NO MEMEs. Add a meme from above.</p>
  </div>

  <admin_entry each={ myMemes }></admin_entry>

  <script>
    //console.log(this);
    var tag = this;

    //local database is always empty, and read dynamicly from fb.
    this.myMemes = [];

    //prepare to push into memes subdirectory in our database
    var messagesRef = rootRef.child('/memes');

    this.saveMeme = function () {
      var key = messagesRef.push().key;
      var meme = {
        id: key,
        url: this.refs.urlEl.value,
        caption: this.refs.captionEl.value,
        funness: this.refs.funnyEl.value
      }
      messagesRef.child(key).set(meme);

      //clean up default input values
      this.refs.urlEl.value = "";
      this.refs.captionEl.value = "";
      this.refs.funnyEl.value = "";
    }

    // listen to database value change and update result
    messagesRef.on('value', function (snap) {
      let rawdata = snap.val();
      // console.log("rawdata", rawdata);
      let tempData = [];
      for (key in rawdata) {
        tempData.push(rawdata[key]);
      }
      // console.log("myMemes", tag.myMemes);
      tag.myMemes = tempData;

      tag.update();
      observable.trigger('updateMemes', tempData);
    })

    orderResults(event){
      //get order value
      let order = this.refs.order.value;
      // console.log("order", order);

      let orderResult = messagesRef;
      console.log("messagesRef", messagesRef);

      if (order == "funnees"){
        orderResult = orderResult.orderByChild('funness');
        console.log("order by funness", orderResult);
      }else if(order == "caption"){
        orderResult = orderResult.orderByChild('caption');
      }else{
        // default, nothing happens
      }

      orderResult.once('value', function (snap) {
        // let rawdata = snap.val();
        // console.log("datafromfb", datafromfb);
        let tempData = [];

        snap.forEach(function(child) {
           tempData.push(child.val()); // NOW THE CHILDREN PRINT IN ORDER
       });

        tag.myMemes = tempData;

        tag.update();
        observable.trigger('updateMemes', tempData);
      });
    }

    filterResults(event) {
      //get current filter value
      var fun = this.refs.fun.value;
      //order memes by child property funnees
      let queryResult = messagesRef.orderByChild('funness');
      console.log("queryResult", queryResult);

      //combine with additional functions to form complex queries
      if (fun == "nofun") {
        queryResult = queryResult.equalTo("0");
          console.log("queryResult for no fun", queryResult);
      } else if (fun == "veryfun") {
        queryResult = queryResult.equalTo("5");
        console.log("queryResult for very full", queryResult);
      } else if (fun == "somewhatfun") {
        queryResult = queryResult.startAt('1').endAt('4');
        console.log("queryResult for some fun", queryResult);
      } else {
        //default, no query needed
      }

      queryResult.once('value', function (snap) {
        let rawdata = snap.val();
        // console.log("datafromfb", datafromfb);
        let tempData = [];
        for (key in rawdata) {
          tempData.push(rawdata[key]);
        }
        // console.log("myMemes", tag.myMemes);
        tag.myMemes = tempData;

        tag.update();
        observable.trigger('updateMemes', tempData);
      });
    }
  </script>


  <style>
    :scope {
      display: block;
      padding: 2em;
    }


    .memeMaker {
      padding: 2em;
      margin-top: 2em;
      background-color: grey;
    }

    .order{
      padding: 2em;
      margin-top: 2em;
      background-color: powderblue;
    }

    .filter{
      padding: 2em;
      margin-top: 2em;
      background-color: steelblue;
    }
  </style>
</admin>
