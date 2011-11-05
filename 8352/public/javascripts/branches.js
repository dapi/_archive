Array.prototype.remove = function(from, to) {
  var rest = this.slice((to || from) + 1 || this.length);
  this.length = from < 0 ? this.length + from : from;
  return this.push.apply(this, rest);
};

Array.prototype.delete = function(value) {
  if (this.indexOf(value) == -1) return this;
  return this.remove(this.indexOf(value));
};

Array.prototype.uniq = function(value) {
  var sorter = {};
  var out = [];
  for(var i=0,j=this.length;i<j;i++){
    if(!sorter[this[i]+typeof this[i]]){
      out.push(this[i]);
      sorter[this[i]+typeof this[i]]=true;
    }
  }
  return out;
};

Branch = {
  initialize: function() {
    $('#loader').ajaxStart(function() { $(this).show(); });
    $('#loader').ajaxStop(function() { $(this).hide(); });

    $('#branches dt')
     .live('mouseover', function(e) { $(this).find('._edit').show(); })
     .live('mouseout', function(e) { $(this).find('._edit').hide(); });    
    
    $('a._delete').live('click', function(e) {
      e.preventDefault();
      $.ajax({
        type: 'get',
        dataType: 'script',
        data: {
          _method: '_delete',
          authenticity_token: window._token,
          "visibility[]": Branch.visibility
        },
        url: $(this).attr('href')
      }); 
    });

    $('a._move_up, a._move_down').live('click', function(e) {
      e.preventDefault();
      $.ajax({
        type: 'post',
        dataType: 'script',
        data: {
          authenticity_token: window._token,
          "visibility[]": Branch.visibility
        },
        url: $(this).attr('href')
      }); 
    });

    $('#branches ._close').live('click', function() {
      Branch.close($(this).attr('rel'));
    });
    
    $('#branches ._open').live('click', function() {
      Branch.open($(this).attr('rel'));
    });  

    Branch.visibility = $.cookie('tree_visibility_8352').split(',');
    Branch.reset();
  },

  reset: function() {
    $('#branch_root, #branches ._branch').droppable({
      accept: '._branch, ._group',
      hoverClass: 'hover',
      drop: function(event, ui) {      
        var target = $(this).attr('id');
        $.ajax({
          type: 'post',
          //dataType: 'script',
          data: {
            clone: $(ui.helper).hasClass('gclone'),
            source: $(ui.draggable).attr('id'),
            target: target,
            authenticity_token: window._token,
            "visibility[]": Branch.visibility
          },
          success: function(script,args) {
            eval(script);
            Branch.open(target.slice(7));
          },
          url: '/admin/branches/move'
        });
      }
    });

    $('#branches ._branch').draggable({
      revert: 'invalid',
      handle: '._move',
      helper: function() {
        return "<div class='helper'>"+$(this).attr('rel')+"</div>"
      }
    });
    
    $('#branches ._group').draggable({
      revert: 'invalid',
      handle: '._move ._clone',
      helper: function() {
        return "<div class='helper'>"+$(this).attr('rel')+"</div>"
      },
      start: function(event, ui) {
        if ($(event.originalEvent.originalTarget).hasClass('_clone')) {
          $(ui.helper).addClass('gclone');
        }
      }
    });
    
    $('#groups ._group').draggable({
      revert: 'invalid',
      handle: '._move',
      helper: function() {
        return "<div class='helper'>"+$(this).attr('rel')+"</div>"
      },    
    });
  },
  open: function(id) {
    var dl_id = '#parent_' + id;
    if ($(dl_id).length > 0) {
      var b_id = "#open_" + id;
      $(dl_id).show();
      $(b_id).hide();
      $(b_id).parent().find('._close').show();
      Branch.visibility.push(id);
    } else {
      Branch.visibility.delete(id);
    }
    Branch.saveVisibility();
  },
  close: function(id) {
    var dl_id = '#parent_' + id;      
    var b_id = "#close_" + id;
    $(dl_id).hide();
    $(b_id).hide();
    $(b_id).parent().find('._open').show();
    Branch.visibility.delete(id);
    Branch.saveVisibility();
  },
  saveVisibility: function() {
    Branch.visibility = Branch.visibility.uniq();
    $.cookie("tree_visibility_8352", Branch.visibility.toString());    
  },
  visibility: []
};
