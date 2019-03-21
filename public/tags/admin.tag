<admin>
  <div class="memeMaker">
    <input type="text" ref="urlEl" placeholder="Enter url">
    <input type="text" ref="captionEl" placeholder="Enter caption">
    <input type="text" ref="funnyEl" placeholder="Enter funness (0 to 5)">
    <button type="button" onclick={ saveMeme }>Add Meme</button>
  </div>

  <div class="filter">
    <p>Select level of fun</p>
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

    //prepare to push into memes subdirectory in our database
    var messagesRef = rootRef.child('/memes');

    this.myMemes = [];


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

    messagesRef.on('value', function (snap) {
      let datafromfb = snap.val();
      console.log("datafromfb", datafromfb);
      var tempData = [];
      for (key in datafromfb){
          tempData.push(datafromfb[key]);
      }
      // console.log("myMemes", tag.myMemes);
      tag.myMemes = tempData;
      observable.trigger('updateMemes', tempData);

      tag.update();
    });

    getResults(event) {
  console.log('getResults()');
  var fun = this.refs.fun.value; // ""

  if (fun=="nofun") {
    messagesRef.orderByChild('funness').equalTo(0)
    .once('value', function(snap) {
      var data = snap.val();
      var tempMemes = [];
      for (var key in data) {
        tempMemes.push(data[key]);
      }

      tag.myMemes = tempMemes;
      tag.update();
    });
  } else {
    candidatesRef.orderByChild('funnees').once('value', function(snap) {
      var data = snap.val();
      var tempMemes = [];
      for (var key in data) {
        tempMemes.push(data[key]);
      }

      tag.myMemes = tempMemes;
      tag.update();
    });
  }

}
  </script>


  <style>
    :scope {
      display: block;
      padding: 2em;
    }

    .memeMaker, .filter{
      padding: 2em;
      margin-top: 2em;
      background-color: grey;
    }


  </style>
</admin>
