// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require fontawesome
//= require spinner
//= require date_picker
//= require Jcrop
//= require bootstrap-sprockets
//= require_tree .

$(document).on('turbolinks:load', function(){
	$('#menu-btn').click(function(){
		$('#main-menu').animate({left: "+=280"});
		$('#menu-overlay').fadeIn(300);
		$('#main-menu-workouts').click();
	});
	$('#menu-overlay').click(function(){
		$('#main-menu').animate({left: "-=280"});
		$(this).fadeOut(300);
	});
	$('#top-menu-caret').click(function(){$('#top-menu-workouts').click()});
	$('#alerts-btn').click(function(){$('#alert-menu-target').click()});
	$('#friend-menu-btn').click(function(){$('#friend-menu-target').click()});
	$('#contest-menu-btn').click(function(){$('#contest-menu-target').click()});
	$('#open-emoji-modal').click(function(){$('#get-emoji-form').click()});
	$('.login-toggle').click(function(e){
		e.stopPropagation();
		$('#login-btn').dropdown('toggle');
	});
	$('#login-modal-btn').click(function(e){
		e.stopPropagation();
		$('#login-modal').modal('hide');
		$('#login-btn').dropdown('toggle');
	});
	$('#leaderboard-filter select').change(function(){
		$('#leaderboard-filter').submit();
		$('#leaderboard-target').replaceWith('<div id="leaderboard-target" class="wait-container text-center full-pad"><span></span><span></span><span></span><span></span></div>');
	});
	$('#add-friend-btn').click(function(){
		$(this).addClass('disabled');
		$(this).text('Friend Request Pending...');
	});
	$('.confirm-friend-btns a').click(function(){
		$('.confirm-friend-btns a').addClass('disabled');
	});
	$('#staging_email').keydown(function(){
		if(/^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/.test($(this).val())){$('#staging-btn').removeClass('disabled')}
		else{$('#staging-btn').addClass('disabled')};
	});
	$('#staging_email').change(function(){
		if(/^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/.test($(this).val())){$('#staging-btn').removeClass('disabled')}
		else{$('#staging-btn').addClass('disabled')};
	});
	$('#contest_staging_email').keydown(function(){
		if(/^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/.test($(this).val())){$('#contest-staging-btn').removeClass('disabled')}
		else{$('#contest-staging-btn').addClass('disabled')};
	});
	$('#contest_staging_email').change(function(){
		if(/^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/.test($(this).val())){$('#contest-staging-btn').removeClass('disabled')}
		else{$('#contest-staging-btn').addClass('disabled')};
	});
	$('#load-more').click(function(){
		$(this).replaceWith('<div id="wc" class="wait-container"><span></span><span></span><span></span><span></span></div>')
	});
	$('.get-replies').click(function(){
		var i = $(this).data('id');
		$(this).replaceWith('<div id="reply-wc-'+i+'" class="wait-container"><span></span><span></span><span></span><span></span></div>')
	});
	$('.retrieve-likes').click(function(){$('#like-modal').modal('show')});
	$('#like-modal').on('hidden.bs.modal', function (){
		$('#like-content').replaceWith('<div class="modal-content" id="like-content"><div class="wait-container add-pad-30 text-center"><span></span><span></span><span></span><span></span></div></div>');
	});
	$('.more-comments-btn').click(function(){
		var t = $(this).data('thing');
		$(this).replaceWith('<div id="wc-'+t+'" class="wait-container"><span></span><span></span><span></span><span></span></div>')
	});
	$('.reply-btn').click(function(){
		$(this).siblings('.wait-container').removeClass('no-show');
	});
	$(".workout-collapse").click(function(){var c=$(this).data("id");$("#comment-target-"+c).click()});
	$('.async-load-btn').click();
	$('#learn-more a').click(function(){
		var s = $('#scroll-to').offset().top - 50;
		$('html, body').animate({
			scrollTop: s
		}, 600);
	});
	$('.instr-edit').click(function(){$(this).replaceWith('<div class="wait-container dib middle-align"><span></span><span></span><span></span><span></span></div>')});
	$('.close-notif').click(function(){$(this).parent().remove()});
	$('.add-friend-btn').click(function(){$(this).addClass('disabled')});
	$('#invite-contestants-modal').on('shown.bs.modal', function(){$('#contestant-friend-list').click()});
	$('a#load-performers').click(function(){$(this).replaceWith('<div id="load-performers" class="wait-container full-pad text-center"><span></span><span></span><span></span><span></span></div>')});
});
$(document).on('turbolinks:load', function(){
	$("#account-submit-btn").click(function(e) {
		e.preventDefault();
		$("#new_user input").removeClass("bad-input");
		var a = $("#user_name"), b = $("#user_email"), c = $("#user_password");
		if ((/^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$/.test(a.val())===false)){
			a.addClass('bad-input');
			a.focus();
			$('#error-msg-signup p').replaceWith('<p><span>!</span>Please enter your full name!</p>');
		}
		else if ((/^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/.test(b.val())===false)){
			b.addClass('bad-input');
			b.focus();
			$('#error-msg-signup p').replaceWith('<p><span>!</span>Please enter a valid email!</p>');
		}
		else if (c && c.val().length < 8){
			c.addClass('bad-input');
			c.focus();
			$('#error-msg-signup p').replaceWith('<p><span>!</span>Please enter a password of at least 8 characters!</p>');
		}
		else{
			$(this).addClass('disabled');
			$("#new_user").submit()
		};
	});
	$("#new_user input").change(function(){
		$(this).removeClass('bad-input');
	});
	$("#login-submit-btn").click(function(){
		$(this).addClass('disabled');
	});
	$('#change_view_form select').change(function(){$('#change_view_form').submit()});
	$('.info-bubble').mouseover(function(){$(this).addClass('hovered')});
	$('.info-bubble').mouseleave(function(){$(this).removeClass('hovered')});
	$('.info-bubble').click(function(){$(this).toggleClass('hovered')});
	$('.current-section').mouseover(function(){$(this).addClass('hovered')});
	$('.current-section').mouseleave(function(){$(this).removeClass('hovered')});
});
$(document).on('turbolinks:load', function() {
	$("div.notice-wrapper").slideDown(200, function(){
		setTimeout(function(){ 
			$("div.notice-wrapper").fadeOut("slow", function() { 
				$("div.notice-wrapper").remove(); 
			}); 
		}, 4000);
	});
	$("div#close-flash").click(function(){
		$("div#flash-container").fadeOut("fast", function() {
			$("div#flash-container").remove();
		});
	});
})
$(document).on('turbolinks:load', function(){
	$('.like-btn').click(function(){
		$(this).toggleClass('liked');
	});
	$('.comment-input').keyup(function(){
		var a = $(this).val();
		var b = $(this).siblings('.comment-alert');
		var i = $(this).siblings('input[type="submit"]');
		var m = $(this).siblings('.mirror');
		m.text(a+'\u00A0');
		var mw = m.width();
		var iw = $(this).width() - 24;
		var h = Math.max((22*Math.ceil(mw/iw)), 22);
		$(this).height(h);
		if ((a.length < 251) && (a.length > 0)){i.removeClass('disabled')}
		else{i.addClass('disabled')};
		if (a.length > 240){
			c = 250 - a.length;
			b.removeClass('no-show');
			b.children('.count').replaceWith('<span class="count">'+c+'</span>');
		}
		else{b.addClass('no-show')};
	});
});
$(document).on('turbolinks:load', function(){
	$('#video-btn').click(function(){
		$('#yt-input').toggleClass('closed');
		$('#pic-input').toggleClass('no-show');
		$('#remove-vid').toggleClass('no-show');
	});
	$('#remove-vid').click(function(){
		$('#yt-input').addClass('closed');
		$('#pic-input').removeClass('disabled');
		$('#pic-input').removeClass('no-show');
		$('#remove-vid').addClass('no-show');
		$('#yt-input input').val('');
		$('#video-btn').removeClass('btn-vimeo');
		$('#video-btn').removeClass('btn-youtube');
		$('#video-btn').addClass('btn-picture');
	});
	$('#remove-pic').click(function(){
		$('input[type="file"]').val("");
		$('#pic-value').text('');
		$('#pic-input').removeClass('disabled');
		$(this).addClass('no-show');
		$('#file-errors').text("");
		$('#yt-input').removeClass('no-show');
		$('#post-submit-btn').removeClass('disabled');
		$('#delete_post_image').val("1");
	});
	$('#pic-input').click(function(){
		$('#post_image').click();
	});
	$('#post_image').change(function(){
		$('#file-errors').text("");
		var v = $(this).val();
		if (v){
			var size = $(this)[0].files[0].size;
			var filename = v.replace(/^.*[\\\/]/, '');
			if (size > 4194304){
				$('#file-errors').text("This file is too large. Please choose a file smaller than 4MB.");
				$('#post-submit-btn').addClass('disabled');
			}
			else if (!(/\.(gif|jpg|jpeg||png)$/i).test(filename)){
				$('#file-errors').text("This not a valid file type. Please select a GIF, JPG, JPEG or PNG file.");
				$('#post-submit-btn').addClass('disabled');
			}
			else{$('#post-submit-btn').removeClass('disabled')};
			$('#yt-input').addClass('no-show');
			$('#pic-value').text(filename);
			$('#remove-pic').removeClass('no-show');
			$('#pic-input').addClass('disabled');
		}
		else {$('#yt-input').removeClass('no-show'), $('#remove-pic').addClass('no-show')};
	});
	$('#post_comment').keyup(function(){
		a = $(this).val();
		if (a.length > 240){
			c = 250 - a.length;
			$('#alert').removeClass('no-show');
			$('#count').replaceWith('<span id="count">'+c+'</span>');
			if (a.length > 250){$('#post-submit-btn').addClass('disabled')}
			else{$('#post-submit-btn').removeClass('disabled')}
		}
		else{$('#alert').addClass('no-show')};
	});
	$('#post_video_url').change(function(){
		if (/(?:youtube(?:-nocookie)?\.com\/(?:[^\/\n\s]+\/\S+\/|(?:v|e(?:mbed)?)\/|\S*?[?&]v=)|youtu\.be\/|vimeo\.com\/)([a-zA-Z0-9_-]{8,11})/.test($(this).val())){
			if (/youtu/.test($(this).val())){
				$('#video-btn').removeClass('btn-picture');
				$('#video-btn').removeClass('btn-vimeo');
				$('#video-btn').addClass('btn-youtube');
			}
			else if (/vimeo/.test($(this).val())){
				$('#video-btn').removeClass('btn-picture');
				$('#video-btn').removeClass('btn-youtube');
				$('#video-btn').addClass('btn-vimeo');
			};
		}
		else{
			$('#video-btn').removeClass('btn-vimeo');
			$('#video-btn').removeClass('btn-youtube');
			$('#video-btn').addClass('btn-picture');
		};
	});
});
$(document).on('turbolinks:load', function(){
	$('#submit-contact').click(function(e){
		e.preventDefault();
		var a = $('#contact_category').val(), b = $('#contact_name').val(), c = $('#contact_email').val(), d = $('#contact_content').val();
		var arr = [a,b,c,d];
		var msg = ["Please select a category", "Please enter your first and last name", "Please enter a valid email address", "Please enter a message"];
		var ok = true;
		for (i=0;i<4;i++){
			if (!arr[i]){
				alert(msg[i]);
				ok = false;
				break;
			};
		};
		if(ok){$('#new_contact').submit()};
	});
});
$(document).on('turbolinks:load', function(){
	$('#avatar_image').change(function(){
		var v = $(this).val();
		if (v){
			var filename = v.replace(/^.*[\\\/]/, '');
			var size = $(this)[0].files[0].size;
			if (size > 4194304){
				alert("This file is too large. Please choose a file smaller than 4MB.");
			}
			else if (!(/\.(gif|jpg|jpeg||png)$/i).test(filename)){
				alert("This not a valid file type. Please select a GIF, JPG, JPEG or PNG file.");
			}
			else{
				$('#change-image-modal').modal('show');
				$('#change-pic-form').submit();
				$('#prof-pic-btn').replaceWith('<div class="wait-container"><span></span><span></span><span></span><span></span></div>');
			};
		}
	});
	$('#prof-pic-btn').click(function(){$('#avatar_image').click()});
});
$(document).on('turbolinks:load', function(){
	if($('#more-posts').length > 0){
		var h = 1000;
		var exArr = [];
		$(window).scroll(function(){
			var a = $('#more-posts');
			var p = a.offset().top;
			var t = $(window).scrollTop();
			var o = a.data('o');
			if ((p < (t + h)) && (exArr.indexOf(o)===-1)){
				a.click();
				exArr.push(o);
			};
		});
	}
	else{$(window).unbind('scroll')};
});
$(document).on('turbolinks:load', function(){
	$.widget( "ui.customspinner", $.ui.spinner, {
		_format: function(value) { if (value===1){return value + ' ' + this.options.units}
		else {return value + ' ' + this.options.units + 's'} },
		_parse: function(value) { return parseInt(value); }
	});
	$('.custom-spinner').each(function(){
		$(this).customspinner({min: 0, max: $(this).data('max'), units: $(this).data('units')});
	});
	$('.ui-spinner-down').text("-");
	$('.ui-spinner-up').text("+");
	$('.custom-spinner').change(function(){
		var u = ' ' + $(this).data('units');
		var v = parseInt($(this).val());
		var m = parseInt($(this).data('max'));
		if ((v > m) && m){v = m};
		if(v===1){$(this).val(v+u)}
		else{
			if(v){$(this).val(v+u+'s')}
			else{$(this).val('')};
		};
		$('.custom-spinner').removeClass('bad-input');
		$('#error-msg-post p').replaceWith('<p></p>');
	});

	$('#cropbox').Jcrop({aspectRatio: 1, setSelect: [0, 0, 400, 400], onSelect: updateCoords, onChange: updateCoords});
	function updateCoords(c){
		$('#crop_x').val(c.x);
		$('#crop_y').val(c.y);
		$('#crop_w').val(c.w);
		$('#crop_h').val(c.h);
	};
	$('#change-image-modal').modal('show');
	$('#change-image-modal').on('hidden.bs.modal', function(){
		$('#cancel-crop').click();
	});
	$('#save_crop').click(function(){
		$('#cancel-crop').remove();
		$('#crop-buttons').hide();
		$('#crop-wc').removeClass('no-show');
	});
});
function recaptcha_callback(){$('#submit-contact').removeClass("disabled")}
$(document).on('turbolinks:load', function(){
	$('#contest_start_date').datepicker({minDate: 0});
	$('#contest_start_date').change(function(){
		var sd = $('#contest_start_date').val();
		$('#contest_end_date').datepicker({minDate: sd});
		$('#end_date_container').removeClass('no-show');
	});
	$('#new_contest').children().change(function(){
		var cTitle = $('#contest_contest_title').val();
		var cOpt = $('#contest_owner_invite_only').val();
		var sd = $('#contest_start_date').val();
		var ed = $('#contest_end_date').val();
		if (cTitle && cOpt && sd && ed){
			$('#create_contest').removeClass('disabled');
		}
	});
	$('#create_contest').click(function(e){
		e.preventDefault();
		var cTitle = $('#contest_contest_title').val();
		var cOpt = $('#contest_owner_invite_only').val();
		var sd = $('#contest_start_date').val();
		var ed = $('#contest_end_date').val();
		if (cTitle && cOpt && sd && ed){
			if(cTitle.length > 30){
				alert('The contest title cannot exceed 30 characters');
				$('#contest_contest_title').focus();
			}
			else{$('#new_contest').submit()}
		}
		else{alert('Please populate all fields')}
	});
});
