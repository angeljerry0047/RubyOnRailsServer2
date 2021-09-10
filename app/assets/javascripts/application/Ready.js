var types = ['button', 'submit', 'reset', 'hidden', 'checkbox', 'radio'];
jQuery.extend(jQuery.expr[':'], { 
    h5Text: function (elem) {    
       return jQuery.inArray(elem.type, types) === -1
    }
});

function fulltrim (text){
    return text.replace(/(?:(?:^|\n)\s+|\s+(?:$|\n))/g,'').replace(/\s+/g,' ');
};

$(document).ready(function() {
    var corrections;
    if($('#user_organization_name').length > 0 || $('#opportunities__organization_name').length > 0 )  {
       corrections =  setCorrections(corrections);
    }
    
        var carousel = $("#carousel").featureCarousel(); 
        $('.tracker-individual-container').hide();
        $('input:h5Text').not('textarea').not('#best_practice_ext_link').attr('maxlength','75');
        $('textarea').attr('maxlength','2000');
         
        $('#user_organization_name,#opportunities__organization_name').blur(function(){                     
            for(var i=0;i< corrections.length ;i++ ){                
                if($(this).val().toUpperCase().replace(/ /g,'') === corrections[i].wrong.toUpperCase().replace(/ /g,'')) {                    
                    $(this).val(corrections[i].rigth);
                }
            }
        });  
  });


function setCorrections(corrections){
    return corrections = [
      {"wrong":'wal-mart',"rigth":"Walmart Stores, Inc."},{"wrong":'walmart',"rigth":"Walmart Stores, Inc."}, {"wrong":'wal mart',"rigth":"Walmart Stores, Inc."},{"wrong":'wal-mart stores',"rigth":"Walmart Stores, Inc."}, {"wrong":'walmart stores',"rigth":"Walmart Stores, Inc."}, {"wrong":'wal mart stores',"rigth":"Walmart Stores, Inc."},
      {"wrong":'Tyson',"rigth":"Tyson Foods, Inc. "},{"wrong":'Tyson foods,Inc',"rigth":"Tyson Foods, Inc. "},{"wrong":'Tyson inc',"rigth":"Tyson Foods, Inc. "},{"wrong":'Tyson food inc',"rigth":"Tyson Foods, Inc. "},{"wrong":'Tyson foods in',"rigth":"Tyson Foods, Inc. "},
      {"wrong":'JBHunt',"rigth":"J.B. Hunt"},{"wrong":' J.B.Hunt',"rigth":"J.B. Hunt"},{"wrong":' J.B Hunt',"rigth":"J.B. Hunt"},{"wrong":' J B.Hunt',"rigth":"J.B. Hunt"},      {"wrong":' J B Hunt',"rigth":"J.B. Hunt"},
      {"wrong":'Softek',"rigth":"Softtek"},{"wrong":'softekk',"rigth":"Softtek"},
      {"wrong":'gral mills',"rigth":"General Mills"},{"wrong":' gen mills',"rigth":"General Mills"},
      {"wrong":'silver parker',"rigth":"SilverParker Group"},{"wrong":'silver parker grp',"rigth":"SilverParker Group"},{"wrong":'silver parker gr',"rigth":"SilverParker Group"},{"wrong":'silverparker grp',"rigth":"SilverParker Group"},{"wrong":'silverparker g,',"rigth":"SilverParker Group"},	
      {"wrong":'delmonte',"rigth":"Del Monte"},{"wrong":' delmonte inc,',"rigth":"Del Monte"},
      {"wrong":'nwa council',"rigth":"Northwest Arkansas Council"},{"wrong":' northwest ar council',"rigth":"Northwest Arkansas Council"},
      {"wrong":'the jones t',"rigth":"The Jones Trust"},{"wrong":' the jones trust',"rigth":"The Jones Trust"},{"wrong":' jones trust',"rigth":"The Jones Trust"},
      {"wrong":'proctor and gamble',"rigth":"Proctor & Gamble"},{"wrong":' proctor&gamble',"rigth":"Proctor & Gamble"},{"wrong":' proctorandgamble',"rigth":"Proctor & Gamble"},
      {"wrong":'Mitchell comm grp',"rigth":"Mitchell Communications Group"},{"wrong":' Mitchell comm group',"rigth":"Mitchell Communications Group"},{"wrong":' Mitchell c g',"rigth":"Mitchell Communications Group"},{"wrong":' Mitchell communications g',"rigth":"Mitchell Communications Group"},{"wrong":' Mitchell communication grp,',"rigth":"Mitchell Communications Group"},
      {"wrong":'uofa',"rigth":"University of Arkansas"},{"wrong":' univ.of Arkansas',"rigth":"University of Arkansas"},{"wrong":' univ of Arkansas',"rigth":"University of Arkansas"},{"wrong":'u of a,',"rigth":"University of Arkansas"},
      {"wrong":'tot doc solutions',"rigth":"Total Document Solutions"},{"wrong":' tot doc sol,',"rigth":"Total Document Solutions"}            
    ];
}

/*   $('#user_organization_name').autocorrect({        
      corrections: {            

            'Tyson':"Tyson Foods, Inc. ", 'Tyson foods,Inc':"Tyson Foods, Inc. ",  'Tyson inc':"Tyson Foods, Inc. ", 'Tyson food inc':"Tyson Foods, Inc. ", 'Tyson foods in':"Tyson Foods, Inc. ",
            'JBHunt':"J.B. Hunt",' J.B.Hunt':"J.B. Hunt",' J.B Hunt':"J.B. Hunt",' J B.Hunt':"J.B. Hunt",' J B Hunt':"J.B. Hunt",
            'Softek':"Softtek",' softekk':"Softtek",
            'gral mills':"General Mills",' gen mills':"General Mills",	
            'silver parker':"SilverParker Group",' silver parker grp':"SilverParker Group",' silver parker gr':"SilverParker Group",' silverparker grp':"SilverParker Group",' silverparker g,':"SilverParker Group",	
            'delmonte':"Del Monte",' delmonte inc,':"Del Monte",
            'nwa council':"Northwest Arkansas Council",' northwest ar council':"Northwest Arkansas Council",
            'the jones t':"The Jones Trust",' the jones trust':"The Jones Trust",' jones trust':"The Jones Trust",
            'proctor and gamble':"Proctor & Gamble",' proctor&gamble':"Proctor & Gamble",' proctorandgamble':"Proctor & Gamble",
            'Mitchell comm grp':"Mitchell Communications Group",' Mitchell comm group':"Mitchell Communications Group",' Mitchell c g':"Mitchell Communications Group",' Mitchell communications g':"Mitchell Communications Group",' Mitchell communication grp,':"Mitchell Communications Group",
            'uofa':"University of Arkansas",' univ.of Arkansas':"University of Arkansas",' univ of Arkansas':"University of Arkansas",' u of a,':"University of Arkansas",
            'tot doc solutions':"Total Document Solutions",' tot doc sol,':"Total Document Solutions"            
        }    
  }); 
  */
 
 
