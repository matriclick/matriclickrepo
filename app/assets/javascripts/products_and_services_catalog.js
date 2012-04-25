/*
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
*/
function change_price(){
	if (parseInt($("#service_top_price_range").val()) != 0 ){
		if (parseInt($("#service_top_price_range").val()) < parseInt($("#service_price").val())) {
			$("#service_top_price_range").val(parseInt($("#service_price").val())+1);
		}
	}
}

$(function(){
	$(".datepicker").datepicker({
			onClose: function(dateText, inst) { $(inst.input).change().focusout(); }, 
			autoSize: true, 
			dateFormat: 'dd-M-yy',
			changeMonth: true,
    	changeYear: true
		});
});

$(function() {
	$('#calendar_search').datepicker({
    onClose: function(dateText, inst) { $(inst.input).change().focusout(); }, 
		autoSize: true,
	  dateFormat: 'dd-M-yy',
    changeMonth: true,
    changeYear: true
	});
});

$(function(){
	$(".isgreen").parent().addClass("green");
	$(".isyellow").parent().addClass("yellow");
	$(".isred").parent().addClass("red");
});