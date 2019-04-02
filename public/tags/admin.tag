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

    })


    orderResults(){
      //1. get order value
      let order = this.refs.order.value;
      // console.log("order", order);

      let orderResult = messagesRef;
      console.log("messagesRef", messagesRef);

      // if order is selected as funnies, then order messages by child propoerty funness
      // if order is selected as caption, then order messages by child propoerty caption
      // if order is elected as default, no need to reorder at specifically

      orderResult.once('value', function (snap) {
        // let rawdata = snap.val();
        // console.log("datafromfb", datafromfb);

        //prepare an empty js array to store firebase data

        //get each child value of the the snapshot, and push child.val() into our temporary database

        //update our tag's myMemes property with sorted firebase data

        //calling our tag to manually update so that changes get reflected on the memes tab


      });
    }

    filterResults(event) {
      //get current filter value

      //order memes by child property funnees.

      // console.log("queryResult", queryResult);

      //further combine order result with additional functions to form complex queries
      //if fun is selected as no fun, then only query for fun score equals to NUMBERX
      //if fun is selected as very fun, then only query for fun score equals to NUMBERX
      //if fun is selected as some fun, then only query for fun score equals to NUMBERX
      //if fun is selected as default, then only query for fun score equals to NUMBERX

      queryResult.once('value', function (snap) {
        //retrieve raw data from firebase
        // console.log("datafromfb", datafromfb);

        //set up empty js array to prepare for array transfer

        //use for loop to loop through raw data according to each key property and push into empty array

        //update tag's data array to our temporary js array

        //update tag value to be reflected on memes.tag page

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
