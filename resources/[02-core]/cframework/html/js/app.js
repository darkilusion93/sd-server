let scPlayer = null;
let baseVolume = 100;   // SoundCloud volume is 0 – 100
let maxDistance = 25.0;
let isPlaying = false;
let forcingMute = false;

function createSoundCloudPlayer(url, elapsedTime) {
    const iframe = document.getElementById('sc-player');

    iframe.src = `https://w.soundcloud.com/player/?url=${encodeURIComponent(url)}&auto_play=true`;

    scPlayer = SC.Widget(iframe);
    scPlayer.setVolume(0);

    scPlayer.bind(SC.Widget.Events.READY, function () {
        scPlayer.play();
        forcingMute = true;
        scPlayer.setVolume(0);
        scPlayer.seekTo((elapsedTime || 0) * 1000); 
    });

    setTimeout(() => {
        scPlayer.seekTo((elapsedTime || 0) * 1000);
        scPlayer.setVolume(0);
        forcingMute = false;
    }, 2000);
}

let currentVolume = 0; // keep track of current volume for fading

function updateVolumeByDistance(distance) {
    if (!scPlayer) return;

    const targetVolume = forcingMute ? 0 : baseVolume * Math.max(0, 1 - distance / maxDistance);

    // If forcing mute is true, immediately mute and stop any ongoing fade
    if (forcingMute) {
        currentVolume = 0;
        scPlayer.setVolume(0);
        return;
    }

    // adjust volume gradually
    const step = 5.0; // smaller = slower fade
    if (Math.abs(currentVolume - targetVolume) < step) {
        currentVolume = targetVolume;
        scPlayer.setVolume(currentVolume);
        fadeInterval = null;
    } else {
        currentVolume += (currentVolume < targetVolume ? step : -step);
        scPlayer.setVolume(currentVolume);
    }
}

(() => {
	let visable = false;
	let audioPlayer = null;
	let MenuTpl =
		'<div id="menu_{{_namespace}}_{{_name}}" class="menu{{#align}} align-{{align}}{{/align}}">' +
			'<div class="head"><span>{{{title}}}</span></div>' +
				'<div class="menu-items">' + 
					'{{#elements}}' +
						'<div class="menu-item {{#selected}}selected{{/selected}}">' +
							'{{{label}}}{{#isSlider}} : &lt;{{{sliderLabel}}}&gt;{{/isSlider}}' +
						'</div>' +
					'{{/elements}}' +
				'</div>'+
			'</div>' +
		'</div>'
	;

	window.ESX_MENU       = {};
	ESX_MENU.ResourceName = 'cframework';
	ESX_MENU.opened       = {};
	ESX_MENU.focus        = [];
	ESX_MENU.pos          = {};

	ESX_MENU.open = function(namespace, name, data) {

		if (typeof ESX_MENU.opened[namespace] == 'undefined') {
			ESX_MENU.opened[namespace] = {};
		}

		if (typeof ESX_MENU.opened[namespace][name] != 'undefined') {
			ESX_MENU.close(namespace, name);
		}

		if (typeof ESX_MENU.pos[namespace] == 'undefined') {
			ESX_MENU.pos[namespace] = {};
		}

		for (let i=0; i<data.elements.length; i++) {
			if (typeof data.elements[i].type == 'undefined') {
				data.elements[i].type = 'default';
			}
		}

		data._index     = ESX_MENU.focus.length;
		data._namespace = namespace;
		data._name      = name;

		for (let i=0; i<data.elements.length; i++) {
			data.elements[i]._namespace = namespace;
			data.elements[i]._name      = name;
		}

		ESX_MENU.opened[namespace][name] = data;
		ESX_MENU.pos   [namespace][name] = 0;

		for (let i=0; i<data.elements.length; i++) {
			if (data.elements[i].selected) {
				ESX_MENU.pos[namespace][name] = i;
			} else {
				data.elements[i].selected = false;
			}
		}

		ESX_MENU.focus.push({
			namespace: namespace,
			name     : name
		});
		
		ESX_MENU.render();
		$('#menu_' + namespace + '_' + name).find('.menu-item.selected')[0].scrollIntoView();
	};

	ESX_MENU.close = function(namespace, name) {
		
		delete ESX_MENU.opened[namespace][name];

		for (let i=0; i<ESX_MENU.focus.length; i++) {
			if (ESX_MENU.focus[i].namespace == namespace && ESX_MENU.focus[i].name == name) {
				ESX_MENU.focus.splice(i, 1);
				break;
			}
		}

		ESX_MENU.render();

	};

	ESX_MENU.render = function() {

		let menuContainer       = document.getElementById('menus');
		let focused             = ESX_MENU.getFocused();
		menuContainer.innerHTML = '';

		$(menuContainer).hide();

		for (let namespace in ESX_MENU.opened) {
			for (let name in ESX_MENU.opened[namespace]) {

				let menuData = ESX_MENU.opened[namespace][name];
				let view     = JSON.parse(JSON.stringify(menuData));

				for (let i=0; i<menuData.elements.length; i++) {
					let element = view.elements[i];

					switch (element.type) {
						case 'default' : break;

						case 'slider' : {
							element.isSlider    = true;
							element.sliderLabel = (typeof element.options == 'undefined') ? element.value : element.options[element.value];

							break;
						}

						default : break;
					}

					if (i == ESX_MENU.pos[namespace][name]) {
						element.selected = true;
					}
				}

				let menu = $(Mustache.render(MenuTpl, view))[0];
				$(menu).hide();
				menuContainer.appendChild(menu);
			}
		}

		if (typeof focused != 'undefined') {
			$('#menu_' + focused.namespace + '_' + focused.name).show();
		}

		$(menuContainer).show();

	};

	ESX_MENU.submit = function(namespace, name, data) {
		$.post('http://' + ESX_MENU.ResourceName + '/menu_submit', JSON.stringify({
			_namespace: namespace,
			_name     : name,
			current   : data,
			elements  : ESX_MENU.opened[namespace][name].elements
		}));
	};

	ESX_MENU.cancel = function(namespace, name) {
		$.post('http://' + ESX_MENU.ResourceName + '/menu_cancel', JSON.stringify({
			_namespace: namespace,
			_name     : name
		}));
	};

	ESX_MENU.change = function(namespace, name, data) {
		$.post('http://' + ESX_MENU.ResourceName + '/menu_change', JSON.stringify({
			_namespace: namespace,
			_name     : name,
			current   : data,
			elements  : ESX_MENU.opened[namespace][name].elements
		}));
	};

	ESX_MENU.getFocused = function() {
		return ESX_MENU.focus[ESX_MENU.focus.length - 1];
	};


	ESX = {};
	ESX.HUDElements = [];

	ESX.setHUDDisplay = function (opacity) {
		$('#hud').css('opacity', opacity);
	};

	ESX.insertHUDElement = function (name, index, priority, html, data) {
		ESX.HUDElements.push({
			name: name,
			index: index,
			priority: priority,
			html: html,
			data: data
		});

		ESX.HUDElements.sort((a, b) => {
			return a.index - b.index || b.priority - a.priority;
		});
	};

	ESX.updateHUDElement = function (name, data) {

		for (let i = 0; i < ESX.HUDElements.length; i++) {
			if (ESX.HUDElements[i].name == name) {
				ESX.HUDElements[i].data = data;
			}
		}

		ESX.refreshHUD();
	};

	ESX.deleteHUDElement = function (name) {
		for (let i = 0; i < ESX.HUDElements.length; i++) {
			if (ESX.HUDElements[i].name == name) {
				ESX.HUDElements.splice(i, 1);
			}
		}

		ESX.refreshHUD();
	};

	ESX.refreshHUD = function () {
		$('#hud').html('');

		for (let i = 0; i < ESX.HUDElements.length; i++) {
			let html = Mustache.render(ESX.HUDElements[i].html, ESX.HUDElements[i].data);
			$('#hud').append(html);
		}
	};

	ESX.inventoryNotification = function (add, item, count) {
		let notif = '';

		if (add) {
			notif += '+';
		} else {
			notif += '-';
		}

		notif += count + ' ' + item.label;

		let elem = $('<div>' + notif + '</div>');

		$('#inventory_notifications').append(elem);

		$(elem).delay(3000).fadeOut(1000, function () {
			elem.remove();
		});
	};

	
	let MenuTpl2 =
		'<div id="menu_{{_namespace}}_{{_name}}" class="dialog {{#isBig}}big{{/isBig}}">' +
			'{{#isDefault}}<input type="text" name="value" placeholder="{{title}}" id="inputText"/>{{/isDefault}}' +
				'{{#isBig}}<textarea name="value"/>{{/isBig}}' +
				'<button type="button" name="submit">Aceitar</button>' +
				'<button type="button" name="cancel">Cancelar</button>'
			'</div>' +
		'</div>'
	;

	window.ESX_MENU2       = {};
	ESX_MENU2.ResourceName = 'cframework';
	ESX_MENU2.opened       = {};
	ESX_MENU2.focus        = [];
	ESX_MENU2.pos          = {};

	ESX_MENU2.open = function(namespace, name, data) {

		if(typeof ESX_MENU2.opened[namespace] == 'undefined')
			ESX_MENU2.opened[namespace] = {};

		if(typeof ESX_MENU2.opened[namespace][name] != 'undefined')
			ESX_MENU2.close(namespace, name);

		if(typeof ESX_MENU2.pos[namespace] == 'undefined')
			ESX_MENU2.pos[namespace] = {};

		if(typeof data.type == 'undefined')
			data.type = 'default';

		if(typeof data.align == 'undefined')
			data.align = 'top-left';

		data._index     = ESX_MENU2.focus.length;
		data._namespace = namespace;
		data._name      = name;

		ESX_MENU2.opened[namespace][name] = data;
		ESX_MENU2.pos   [namespace][name] = 0;

		ESX_MENU2.focus.push({
			namespace: namespace,
			name     : name
		});

		document.onkeyup = function (key) {
			if (key.which == 27) { // Escape key
				$.post('http://' + ESX_MENU2.ResourceName + '/menu_cancel2', JSON.stringify(data));
			} else if (key.which == 13) { // Enter key
				$.post('http://' + ESX_MENU2.ResourceName + '/menu_submit2', JSON.stringify(data));
			}
		};

		ESX_MENU2.render();
	}

	ESX_MENU2.close = function(namespace, name) {
		
		delete ESX_MENU2.opened[namespace][name];

		for(let i=0; i<ESX_MENU2.focus.length; i++){
			if(ESX_MENU2.focus[i].namespace == namespace && ESX_MENU2.focus[i].name == name){
				ESX_MENU2.focus.splice(i, 1);
				break;
			}
		}

		ESX_MENU2.render();
	}

	ESX_MENU2.render = function() {

		let menuContainer = $('#menus2')[0];
		
		$(menuContainer).find('button[name="submit"]').unbind('click');
		$(menuContainer).find('button[name="cancel"]').unbind('click');
		$(menuContainer).find('[name="value"]')       .unbind('input propertychange');

		menuContainer.innerHTML = '';

		$(menuContainer).hide();

		for(let namespace in ESX_MENU2.opened){
			for(let name in ESX_MENU2.opened[namespace]){

				let menuData = ESX_MENU2.opened[namespace][name];
				let view     = JSON.parse(JSON.stringify(menuData));

				switch(menuData.type){

					case 'default' : {
						view.isDefault = true;
						break;
					}

					case 'big' : {
						view.isBig = true;
						break;
					}

					default : break;
				}

				let menu = $(Mustache.render(MenuTpl2, view))[0];

				$(menu).css('z-index', 1000 + view._index);

				$(menu).find('button[name="submit"]').click(function() {
					ESX_MENU2.submit(this.namespace, this.name, this.data);
				}.bind({namespace: namespace, name: name, data: menuData}));

				$(menu).find('button[name="cancel"]').click(function() {
					ESX_MENU2.cancel(this.namespace, this.name, this.data);
				}.bind({namespace: namespace, name: name, data: menuData}));

				$(menu).find('[name="value"]').bind('input propertychange', function(){
					this.data.value = $(menu).find('[name="value"]').val();
					ESX_MENU2.change(this.namespace, this.name, this.data);
				}.bind({namespace: namespace, name: name, data: menuData}));

				if(typeof menuData.value != 'undefined')
					$(menu).find('[name="value"]').val(menuData.value);

				menuContainer.appendChild(menu);
			}
		}

		$(menuContainer).show();
		$("#inputText").focus();
	}

	ESX_MENU2.submit = function(namespace, name, data) {
		$.post('http://' + ESX_MENU2.ResourceName + '/menu_submit2', JSON.stringify(data));
	}

	ESX_MENU2.cancel = function(namespace, name, data) {
		$.post('http://' + ESX_MENU2.ResourceName + '/menu_cancel2', JSON.stringify(data));
	}

	ESX_MENU2.change = function(namespace, name, data) {
		$.post('http://' + ESX_MENU2.ResourceName + '/menu_change2', JSON.stringify(data));
	}

	ESX_MENU2.getFocused = function() {
		return ESX_MENU2.focus[ESX_MENU2.focus.length - 1];
	}

	let MenuTplist =
		'<div id="menu_{{_namespace}}_{{_name}}" class="menu3">' +
			'<table>' +
				'<thead>' +
					'<tr>' +
						'{{#head}}<td>{{content}}</td>{{/head}}' +
					'</tr>' +
				'</thead>'+
				'<tbody>' +
					'{{#rows}}' +
						'<tr>' +
							'{{#cols}}<td>{{{content}}}</td>{{/cols}}' +
						'</tr>' +
					'{{/rows}}' +
				'</tbody>' +
			'</table>' +
		'</div>'
	;

	window.ESX_MENU3       = {};
	ESX_MENU3.ResourceName = 'cframework';
	ESX_MENU3.opened       = {};
	ESX_MENU3.focus        = [];
	ESX_MENU3.data         = {}

	ESX_MENU3.open = function(namespace, name, data){

		if(typeof ESX_MENU3.opened[namespace] == 'undefined')
			ESX_MENU3.opened[namespace] = {};

		if(typeof ESX_MENU3.opened[namespace][name] != 'undefined')
			ESX_MENU3.close(namespace, name);

		data._namespace = namespace;
		data._name      = name;

		ESX_MENU3.opened[namespace][name] = data;

		ESX_MENU3.focus.push({
			namespace: namespace,
			name     : name
		});

		document.onkeyup = function(data) {
    
			if(data.which == 27) {
				let focused  = ESX_MENU3.getFocused();
			  	ESX_MENU3.cancel(focused.namespace, focused.name);
			}
		};
		
		ESX_MENU3.render();
	}

	ESX_MENU3.close = function(namespace, name){
		
		delete ESX_MENU3.opened[namespace][name];

		for(let i=0; i<ESX_MENU3.focus.length; i++){
			if(ESX_MENU3.focus[i].namespace == namespace && ESX_MENU3.focus[i].name == name){
				ESX_MENU3.focus.splice(i, 1);
				break;
			}
		}

		ESX_MENU3.render();

	}

	ESX_MENU3.render = function(){

		let menuContainer       = document.getElementById('menus3');
		let focused             = ESX_MENU3.getFocused();
		menuContainer.innerHTML = '';

		$(menuContainer).hide();

		for(let namespace in ESX_MENU3.opened){
			
			if(typeof ESX_MENU3.data[namespace] == 'undefined')
				ESX_MENU3.data[namespace] = {};

			for(let name in ESX_MENU3.opened[namespace]){

				ESX_MENU3.data[namespace][name] = [];

				let menuData = ESX_MENU3.opened[namespace][name];
				let view     = {
					_namespace: menuData._namespace,
					_name     : menuData._name,
					head      : [],
					rows      : []
				}

				for(let i=0; i<menuData.head.length; i++){
					let item = {content: menuData.head[i]};
					view.head.push(item);
				}

				for(let i=0; i<menuData.rows.length; i++){

					let row  = menuData.rows[i];
					let data = row.data;

					ESX_MENU3.data[namespace][name].push(data)

					view.rows.push({cols: []});

					for(let j=0; j<row.cols.length; j++){

						let col     = menuData.rows[i].cols[j];
						let regex   = /\{\{(.*?)\|(.*?)\}\}/g;
						let matches = [];
						let match;

						while ((match = regex.exec(col)) != null)
							matches.push(match)

						for(let k=0; k<matches.length; k++)
							col = col.replace('{{' + matches[k][1] + '|' + matches[k][2] + '}}', '<button data-id="' + i + '" data-namespace="' + namespace + '" data-name="' + name + '" data-value="' + matches[k][2] +'">' + matches[k][1] + '</button>');

						view.rows[i].cols.push({data: data, content: col})

					}

				}

				let menu = $(Mustache.render(MenuTplist, view))

				menu.find('button[data-namespace][data-name]').click(function(){
					ESX_MENU3.submit($(this).data('namespace'), $(this).data('name'), {
						data : ESX_MENU3.data[$(this).data('namespace')][$(this).data('name')][parseInt($(this).data('id'))],
						value: $(this).data('value')
					})
				})

				menu.hide();

				menuContainer.appendChild(menu[0]);
			}
		}

		if(typeof focused != 'undefined')
			$('#menu_' + focused.namespace + '_' + focused.name).show();

		$(menuContainer).show();

	}

	ESX_MENU3.submit = function(namespace, name, data){
		$.post('http://' + ESX_MENU3.ResourceName + '/menu_submit3', JSON.stringify({
			_namespace: namespace,
			_name     : name,
			data      : data.data,
			value     : data.value
		}));
	}

	ESX_MENU3.cancel = function(namespace, name){
		$.post('http://' + ESX_MENU3.ResourceName + '/menu_cancel3', JSON.stringify({
			_namespace: namespace,
			_name     : name
		}));
	}

	ESX_MENU3.getFocused = function(){
		return ESX_MENU3.focus[ESX_MENU3.focus.length - 1];
	}

	ESX.idCardOpen = function(data){
		var type        = data.type;
		var userData    = data.array['user'][0];
		var licenseData = data.array['licenses'];
		var sex         = userData.sex;
		let cardId		= 0;

		$('#name').css('font-size', '18px');
		$('#name').css('margin-top', '1%');
		$('#name').css('margin-left', '-1%');

		$('#dob').css('left', '0');
		$('#dob').css('top', '28px');

		$('#signature').css('bottom', '40px');
		$('#signature').css('left', '152px');

		$('#height').css('left', '37px');
		$('#height').css('top', '-7px');

        $('#citizenid').hide();
  
		if ( type == 'driver' || type == null) {
		  $('#id-card').show();
		  $('#name').css('color', '#282828');
          $('#citizenid').show();
  
		  if ( sex.toLowerCase() == 'm' ) {
			//$('img').attr('src', 'img/idcard/male.png');
			$('#sex').text('M');
		  } else {
			//$('img').attr('src', 'img/idcard/female.png');
			$('#sex').text('F');
		  }
  
		  $('#name').text(userData.firstname + ' ' + userData.lastname);
		  $('#dob').text(userData.dateofbirth);
		  $('#height').text(userData.height);
		  $('#signature').text(userData.firstname + ' ' + userData.lastname);
          $('#citizenid').text(userData.citizen_id);
  
		  if ( type == 'driver' ) {
            $('#citizenid').hide();

			if ( licenseData != null ) {
			Object.keys(licenseData).forEach(function(key) {
			  var type = licenseData[key].type;

			  cardId = licenseData[key].id
  
			  if ( type == 'drive_bike') {
				type = 'bike';
			  } else if ( type == 'drive_truck' ) {
				type = 'truck';
			  } else if ( type == 'drive' ) {
				type = 'car';
			  }
  
			  if ( type == 'bike' || type == 'truck' || type == 'car' ) {
				$('#licenses').append('<p>'+ type +'</p>');
			  }
			});
		  }
  
			$('#id-card').css('background', 'url(img/idcard/license.png)');
		  } else {
			$('#id-card').css('background', 'url(img/idcard/idcard.png)');
		  }
		} else if ( type == 'weapon' ) {
		  $('#id-card').hide();
		  $('#name').css('color', '#131313');
		  $('#name').text(userData.firstname + ' ' + userData.lastname);
		  $('#dob').text(userData.dateofbirth);
		  $('#signature').text(userData.firstname + ' ' + userData.lastname);
  
		  $('#id-card').css('background', 'url(img/idcard/firearm.png)');
		} else if ( type == 'weapon_hunt' ) {
			$('#id-card').hide();
			$('#name').css('color', '#131313');
			$('#name').css('font-size', '15px');
			$('#name').css('margin-top', '15.4%');
			$('#name').css('margin-left', '42%');
			
			Object.keys(licenseData).forEach(function(key) {
				var type = licenseData[key].type;
  
				if ( type == 'weapon_hunt') {
					cardId = licenseData[key].id
				}
			  });

			$('#sex').text('');
			$('#height').text(cardId);

			$('#height').css('left', '123px');
			$('#height').css('top', '43px');

			$('#dob').css('left', '158px');
			$('#dob').css('top', '18px');

			$('#signature').css('bottom', '48px');
			$('#signature').css('left', '180px');

			$('#name').text(userData.firstname + ' ' + userData.lastname);
			$('#dob').text(userData.dateofbirth);
			$('#signature').text(userData.firstname + ' ' + userData.lastname);
	
			$('#id-card').css('background', 'url(img/idcard/hunting.png)');
		}
  
		$('#id-card').show();
	}

	ESX.idCardClose = function(data){
		$('#name').text('');
		$('#dob').text('');
		$('#height').text('');
		$('#signature').text('');
		$('#sex').text('');
		$('#id-card').hide();
		$('#licenses').html('');
	}


    function setFrost(value) {
        let clampedValue = Math.max(0.0, Math.min(1.0, value));
        let clampedScale = 2.0 - clampedValue;

        if (clampedValue > 0.0) {
            $('.frost-container').css('display', 'block');
            setTimeout(() => {
                $('.frost-container').css('opacity', clampedValue.toString());
                $('.frost-container').css('scale', clampedScale.toString());
            }, 10);
        } else {
            $('.frost-container').css('opacity', '0.0');
            $('.frost-container').css('scale', '2.0');
            setTimeout(() => {
                $('.frost-container').css('display', 'none');
            }, 1000);
        }
    }

	
    function ShowNotifPolice(data) {
		var $notification = CreateNotification(data);
		$('.notif-container2').append($notification);
		setTimeout(function() {
			$.when($notification.fadeOut()).done(function() {
				$notification.remove()
			});
		}, data.length != null ? data.length : 2500);
	}

	function CreateNotification(data) {
		var $notification = $(document.createElement('div'));
		//$notification.addClass('notification').addClass(data.type);
		
		if (data.info.isImportant === 1) {
			$notification.addClass('notification2').addClass('officer-down');
	} else {
			if (data.info.isImportant === 2) {
				$notification.addClass('notification2').addClass('ems');
			}
			else{
				$notification.addClass('notification2').addClass(data.style);
			}
	}
		//$notification.html(data.text);
		$notification.html(/*html*/`
			<div class="content">
				<div id="code">${data.info["code"]}</div>
				<div id="alert-name">${data.info["name"]}</div>
			</div>
			<div id="alert-info">${data.info["loc"]}</div>
		`);
		$notification.fadeIn();
		if (data.style !== undefined) {
			Object.keys(data.style).forEach(function(css) {
				$notification.css(css, data.style[css])
			});
		}
		return $notification;
	}

	window.onData = (data) => {
		switch (data.action) {
			case 'updateStatusHud': {
				setProgressZentih(data.varSetVoice,'.progress-micro')
				setProgressZentih(data.varSetHealth,'.progress-health')
				setProgressZentih(data.varSetHunger,'.progress-burger')
				setProgressZentih(data.varSetThirst,'.progress-water')
				setProgressZentih(data.varSetArmor,'.progress-armor')
				setProgressZentih(data.varSetOxy,'.progress-oxygen')
				setProgressZentih(data.varSetDev,'.progress-dev')
		  
				if (data.varSetArmor == 0) {
				  	$('#armor').hide("fast");
				} else {
				  	$('#armor').show("fast");
				}

				if (data.varSetDev == 0) {
					$('#dev').hide("fast");
				} else {
					$('#dev').show("fast");
				}
		  
				if (data.showOxy) {
				  $('#oxy').show("fast");
				} else {
				  $('#oxy').hide("fast");
				}
		  
				if (data.talking) {
				  $("#voice").css("stroke", "rgb(252, 255, 45)");
				  $("#voice1").css("stroke", "rgb(252, 255, 45)");
				} else {
				  $("#voice").css("stroke", "rgb(255, 255, 255)");
				  $("#voice1").css("stroke", "rgb(255, 255, 255)");
				}
				break;
			}

			case 'toggleUi': {
				if (data.value) {
					$('#statusHud').addClass("showStatusHud");
				} else {
					$('#statusHud').removeClass("showStatusHud");
				}
				break;
			}

			case 'mythic': {
				ShowNotif(data);
				break;
			}

            case 'playBoomboxMusic': {
                if (!data.music) return;

                isPlaying = true;
                maxDistance = data.maxDistance || 25.0;

                createSoundCloudPlayer(data.music, data.elapsedTime || 0);
                updateVolumeByDistance(data.distance);
                break;
            }

            case 'updateBoomboxDistance': {
                updateVolumeByDistance(data.distance);
                break;
            }

            case 'stopBoomboxMusic': {
                if (scPlayer) {
                    scPlayer.pause();
                    scPlayer = null;
                }

                isPlaying = false;
                break;
            }

            case 'setBoomboxVolume': {
                baseVolume = Math.min(Math.max(data.volume, 0), 100);
                break;
            }

			case 'openGeneral': {
				$('.general').css('display', 'block')
				break;
			}

			case 'closeAll': {
				$('.general').css('display', 'none')
				break;
			}

			case 'displayAlert': {
				ShowNotifPolice(data);
				break;
			}

			case 'showTaxi': {
				showTaxi();
				break;
			}

			case 'toggleScoreboard':
				if (visable) {
					$('#scoreboard').fadeOut();
				} else {
					$('#scoreboard').fadeIn();
				}

				visable = !visable;
				break;
			case 'scoreboardUpdate': {
				var jobs = data.jobs;

				$('#player_count').html(jobs.player_count);

				//$('#ems').html(jobs.ems);
				//$('#police').html(jobs.police);
				//$('#gnr').html(jobs.gnr);
				//$('#taxi').html(jobs.taxi);
				//$('#mechanic').html(jobs.mechanic);
				/* $('#slaughterer').html(jobs.slaughterer);
				$('#fueler').html(jobs.fueler);
				$('#lumberjack').html(jobs.lumberjack);
				$('#tailor').html(jobs.tailor); */
				//$('#reporter').html(jobs.reporter);
				/* $('#miner').html(jobs.miner); */
				//$('#estate').html(jobs.estate);
				//$('#driftclub').html(jobs.driftclub);
				//$('#ammu').html(jobs.ammu);
				//$('#stato').html(jobs.stato);
				//$('#unemployed').html(jobs.unemployed);
				break;
			}

            case "toggleRadar": {
                if (data.show === false) {
                    $('.radar-container').css('opacity', '0.0');
                    setTimeout(() => {
                        $('.radar-container').css('display', 'none');
                    }, 200);
                    break;
                }

                $('.radar-container').css('display', 'block');
                $('.radar-container').css('opacity', '1.0');
                break;
            }

            case "updateRadar": {
                $("#radar-plate-front").text(data.plateFront);
                $("#radar-plate-back").text(data.plateBack);
                $("#patrol-speed").text(data.speed);

                $("#radar-front-speed").text(data.speedFront);
                $("#radar-back-speed").text(data.speedBack);
                $("#radar-front-max-speed").text(data.maxSpeedFront);
                $("#radar-back-max-speed").text(data.maxSpeedBack);

                break;
            }

			case 'setHUDDisplay': {
				ESX.setHUDDisplay(data.opacity);
				break;
			}

			case 'insertHUDElement': {
				ESX.insertHUDElement(data.name, data.index, data.priority, data.html, data.data);
				break;
			}

			case 'updateHUDElement': {
				ESX.updateHUDElement(data.name, data.data);
				break;
			}

			case 'deleteHUDElement': {
				ESX.deleteHUDElement(data.name);
				break;
			}

			case 'inventoryNotification': {
				ESX.inventoryNotification(data.add, data.item, data.count);
				break;
			}

			case 'idCardOpen': {
				ESX.idCardOpen(data);
				break;
			}

			case 'idCardClose': {
				ESX.idCardClose(data);
				break;
			}

			case 'playSound': {
				if (audioPlayer != null) {
                	audioPlayer.pause();
                }

                audioPlayer = new Howl({src: ["./sounds/" + data.transactionFile + ".ogg"]});
                audioPlayer.volume(data.transactionVolume);
                audioPlayer.play();

				break;
			}

            case 'setFrost': {
				setFrost(data.value);
				break;
			}

			case 'openMenu': {
				ESX_MENU.open(data.namespace, data.name, data.data);
				break;
			}

			case 'closeMenu': {
				ESX_MENU.close(data.namespace, data.name);
				break;
			}

			case 'openMenu2' : {
				ESX_MENU2.open(data.namespace, data.name, data.data);
				break;
			}

			case 'closeMenu2' : {
				ESX_MENU2.close(data.namespace, data.name);
				break;
			}

			case 'openMenu3' : {
				ESX_MENU3.open(data.namespace, data.name, data.data);
				break;
			}

			case 'closeMenu3' : {
				ESX_MENU3.close(data.namespace, data.name);
				break;
			}

			case 'taskbar' : {
				var item = data;
				if (item.runProgress === true) {
					openMain(item.Length);
				}
		  
				if (item.closeFail === true) {
					closeMain();
					$.post('http://cframework/taskCancel', JSON.stringify({
						tasknum: curTask
					}));
					streak = 0;
				}
		  
				if (item.closeProgress === true) {
					closeMain();
					streak = 0;
				}
				break;
			}

			case 'controlPressed': {

				switch (data.control) {

					case 'ENTER': {
						let focused = ESX_MENU.getFocused();

						if (typeof focused != 'undefined') {
							let menu    = ESX_MENU.opened[focused.namespace][focused.name];
							let pos     = ESX_MENU.pos[focused.namespace][focused.name];
							let elem    = menu.elements[pos];

							if (menu.elements.length > 0) {
								ESX_MENU.submit(focused.namespace, focused.name, elem);
							}
						}

						break;
					}

					case 'BACKSPACE': {
						let focused = ESX_MENU.getFocused();

						if (typeof focused != 'undefined') {
							ESX_MENU.cancel(focused.namespace, focused.name);
						}

						break;
					}

					case 'TOP': {

						let focused = ESX_MENU.getFocused();

						if (typeof focused != 'undefined') {

							let menu = ESX_MENU.opened[focused.namespace][focused.name];
							let pos  = ESX_MENU.pos[focused.namespace][focused.name];

							if (pos > 0) {
								ESX_MENU.pos[focused.namespace][focused.name]--;
							} else {
								ESX_MENU.pos[focused.namespace][focused.name] = menu.elements.length - 1;
							}

							let elem = menu.elements[ESX_MENU.pos[focused.namespace][focused.name]];

							for (let i=0; i<menu.elements.length; i++) {
								if (i == ESX_MENU.pos[focused.namespace][focused.name]) {
									menu.elements[i].selected = true;
								} else {
									menu.elements[i].selected = false;
								}
							}

							ESX_MENU.change(focused.namespace, focused.name, elem);
							ESX_MENU.render();

							$('#menu_' + focused.namespace + '_' + focused.name).find('.menu-item.selected')[0].scrollIntoView();
						}

						break;

					}

					case 'DOWN' : {

						let focused = ESX_MENU.getFocused();

						if (typeof focused != 'undefined') {
							let menu   = ESX_MENU.opened[focused.namespace][focused.name];
							let pos    = ESX_MENU.pos[focused.namespace][focused.name];
							let length = menu.elements.length;

							if (pos < length - 1) {
								ESX_MENU.pos[focused.namespace][focused.name]++;
							} else {
								ESX_MENU.pos[focused.namespace][focused.name] = 0;
							}

							let elem = menu.elements[ESX_MENU.pos[focused.namespace][focused.name]];

							for (let i=0; i<menu.elements.length; i++) {
								if (i == ESX_MENU.pos[focused.namespace][focused.name]) {
									menu.elements[i].selected = true;
								} else {
									menu.elements[i].selected = false;
								}
							}

							ESX_MENU.change(focused.namespace, focused.name, elem);
							ESX_MENU.render();

							$('#menu_' + focused.namespace + '_' + focused.name).find('.menu-item.selected')[0].scrollIntoView();
						}

						break;
					}

					case 'LEFT' : {

						let focused = ESX_MENU.getFocused();

						if (typeof focused != 'undefined') {
							let menu = ESX_MENU.opened[focused.namespace][focused.name];
							let pos  = ESX_MENU.pos[focused.namespace][focused.name];
							let elem = menu.elements[pos];

							switch(elem.type) {
								case 'default': break;

								case 'slider': {
									let min = (typeof elem.min == 'undefined') ? 0 : elem.min;

									if (elem.value > min) {
										elem.value--;
										ESX_MENU.change(focused.namespace, focused.name, elem);
									}

									ESX_MENU.render();
									break;
								}

								default: break;
							}

							$('#menu_' + focused.namespace + '_' + focused.name).find('.menu-item.selected')[0].scrollIntoView();
						}

						break;
					}

					case 'RIGHT' : {

						let focused = ESX_MENU.getFocused();

						if (typeof focused != 'undefined') {
							let menu = ESX_MENU.opened[focused.namespace][focused.name];
							let pos  = ESX_MENU.pos[focused.namespace][focused.name];
							let elem = menu.elements[pos];

							switch(elem.type) {
								case 'default': break;

								case 'slider': {
									if (typeof elem.options != 'undefined' && elem.value < elem.options.length - 1) {
										elem.value++;
										ESX_MENU.change(focused.namespace, focused.name, elem);
									}

									if (typeof elem.max != 'undefined' && elem.value < elem.max) {
										elem.value++;
										ESX_MENU.change(focused.namespace, focused.name, elem);
									}

									ESX_MENU.render();
									break;
								}

								default: break;
							}

							$('#menu_' + focused.namespace + '_' + focused.name).find('.menu-item.selected')[0].scrollIntoView();
						}

						break;
					}

					case 'CUSTOM' : {

						let focused = ESX_MENU.getFocused();

						if (typeof focused != 'undefined') {
							let menu = ESX_MENU.opened[focused.namespace][focused.name];
							let pos  = ESX_MENU.pos[focused.namespace][focused.name];
							let elem = menu.elements[pos];

							switch(elem.type) {
								case 'default': break;

								case 'slider': {

									let min = (typeof elem.min == 'undefined') ? 0 : elem.min;

									if (data.number > min && typeof elem.max != 'undefined' && data.number < elem.max) {
										elem.value = data.number;
										ESX_MENU.change(focused.namespace, focused.name, elem);
									}


									ESX_MENU.render();
									break;
								}

								default: break;
							}

							$('#menu_' + focused.namespace + '_' + focused.name).find('.menu-item.selected')[0].scrollIntoView();

						}

						break;
					}

					default : break;

				}

				break;
			}
		}
	};

	window.onload = function (e) {
		window.addEventListener('message', (event) => {
			onData(event.data);
		});
	};

})();

function setProgressZentih(value, element){
	var circle = document.querySelector(element);
	var radius = circle.r.baseVal.value;
	var circumference = radius * 2 * Math.PI;
	var html = $(element).parent().parent().find('span');
	var percent = value*100/100;
  
	circle.style.strokeDasharray = `${circumference} ${circumference}`;
	circle.style.strokeDashoffset = `${circumference}`;
  
	const offset = circumference - ((-percent*99)/100) / 100 * circumference;
	circle.style.strokeDashoffset = -offset;
  
	var predkosc = Math.floor(value * 1.8)
	if (predkosc == 81 || predkosc == 131) {
	  predkosc = predkosc - 1
	}
  
	html.text(predkosc);
}

let notifs = {}

function CreateNotification(data) {
    let $notification = $(document.createElement('div'));
    $notification.addClass('notification').addClass(data.type);
    $notification.html(data.text);
    $notification.fadeIn();
    if (data.style !== undefined) {
        Object.keys(data.style).forEach(function(css) {
            $notification.css(css, data.style[css])
        });
    }

    return $notification;
}

function UpdateNotification(data) {
    let $notification = $(notifs[data.id])
    $notification.addClass('notification').addClass(data.type);
    $notification.html(data.text);

    if (data.style !== undefined) {
        Object.keys(data.style).forEach(function(css) {
            $notification.css(css, data.style[css])
        });
    }
}

function ShowNotif(data) {
    if (data.persist != null) {
        if (data.persist.toUpperCase() == 'START') {
            if (notifs[data.id] === undefined) {
                let $notification = CreateNotification(data);
                $('.notif-container').append($notification);
                notifs[data.id] = {
                    notif: $notification  
                };
            } else {
                UpdateNotification(data);
            }
        } else if (data.persist.toUpperCase() == 'END') {
            if (notifs[data.id] != null) {
                let $notification = $(notifs[data.id].notif);
                $.when($notification.fadeOut()).done(function() {
                    $notification.remove();
                    delete notifs[data.id];
                });
            }
        }
    } else {
        if (data.id != null) {
            if (notifs[data.id] === undefined) {
                let $notification = CreateNotification(data);
                $('.notif-container').append($notification);
                notifs[data.id] = {
                    notif: $notification,
                    timer: setTimeout(function() {
                        let $notification = notifs[data.id].notif;
                        $.when($notification.fadeOut()).done(function() {
                            $notification.remove();
                            clearTimeout(notifs[data.id].timer);
                            delete notifs[data.id];
                        });
                    }, data.length != null ? data.length : 2500)
                };
            } else {
                clearTimeout(notifs[data.id].timer);
                UpdateNotification(data);

                notifs[data.id].timer = setTimeout(function() {
                    let $notification = notifs[data.id].notif;
                    $.when($notification.fadeOut()).done(function() {
                        $notification.remove();
                        clearTimeout(notifs[data.id].timer);
                        delete notifs[data.id];
                    });
                }, data.length != null ? data.length : 2500)
            }
        } else {
            let $notification = CreateNotification(data);
            $('.notif-container').append($notification);
            setTimeout(function() {
                $.when($notification.fadeOut()).done(function() {
                    $notification.remove()
                });
            }, data.length != null ? data.length : 2500);
        }
    }
}



let streakAmount = 1;

var curTask = 0;
let canvas = document.getElementById("taskbarcanvas");
let ctx = canvas.getContext("2d");
let W = canvas.width;
let H = canvas.height;
let degrees = 0;
let new_degrees = 0;
let time = 0;
let color = "#ffffff";
let bgcolor = "#404b58";
let bgcolor2 = "#41a491";
let key_to_press;
let g_start, g_end;
let animation_loop;
let streak = 0;
let percent = 0;
let speed = [8, 10, 15];
let isPlayingMinigame = false;

function getRandomInt(min, max) {
	min = Math.ceil(min);
	max = Math.floor(max);
	return Math.floor(Math.random() * (max - min + 1) + min);
}

function openMain(difficulty) {
	isPlayingMinigame = true;
	if (difficulty===1) {
		speed = [8, 10, 15];
	} else if (difficulty===2) {
		speed = [8, 8, 8];
	} else if (difficulty===3) {
		speed = [4, 4, 4];
	} else if (difficulty===4) {
		speed = [2, 2, 2];
	} else if (difficulty===5) {
		speed = [1, 1, 1];
	}

	$(".taskbar").css("display", "block");
	draw();
}

function closeMain() {
	isPlayingMinigame = false;
	$(".taskbar").css("display", "none");
	streak = 0;
}

function init() {
	ctx.clearRect(0, 0, W, H);
	ctx.beginPath();
	ctx.strokeStyle = bgcolor;
	ctx.lineWidth = 20;
	ctx.arc(W / 2, H / 2, 100, 0, Math.PI * 2, false);
	ctx.stroke();
	ctx.beginPath();
	ctx.strokeStyle = bgcolor2;
	ctx.lineWidth = 20;
	ctx.arc(W / 2, H / 2, 100, g_start - 90 * Math.PI / 180, g_end - 90 * Math.PI / 180, false);
	ctx.stroke();
	let radians = degrees * Math.PI / 180;
	ctx.beginPath();
	ctx.strokeStyle = color;
	ctx.lineWidth = 20;
	ctx.arc(W / 2, H / 2, 100, 0 - 90 * Math.PI / 180, radians - 90 * Math.PI / 180, false);
	ctx.stroke();
	ctx.fillStyle = color;
	ctx.font = "900 100px sans-serif";
	let text_width = ctx.measureText(key_to_press).width;
	ctx.fillText(key_to_press, W / 2 - text_width / 2, H / 2 + 35);
}

function draw() {
	if (typeof animation_loop !== undefined) clearInterval(animation_loop);
	g_start = getRandomInt(15, 32) / 10;
	g_end = getRandomInt(5, 10) / 10;
	g_end = g_start + g_end;
	degrees = 0;
	new_degrees = 360;
	key_to_press = '' + getRandomInt(1, 4);
	time = speed[getRandomInt(0, 2)];

	if (!isPlayingMinigame) return;


	animation_loop = setInterval(animate_to, time);
}

function animate_to() {
	if (degrees >= new_degrees) {
		if (streak > 0) {
			closeMain();
			$.post('http://cframework/taskCancel', JSON.stringify({
				tasknum: curTask
			}));
			streak = 0;
		} else {
			closeMain();
			$.post('http://cframework/taskCancel', JSON.stringify({
				tasknum: curTask
			}));
			wrong();
		}
		return;
	}
	degrees += 2;
	init();
}

function correct() {
	streak++;
	if (streak >= streakAmount) {
		closeMain();
		$.post('http://cframework/taskEnd', JSON.stringify({
			taskResult: percent
		}));
	} else {
		draw();
	}
}

function wrong() {
	streak = 0;
	draw();
}


let taximeterShown = false;
let isTaximeterCounting = false;

function showTaxi() {
	if (!taximeterShown) {
		taximeterShown = true;
		$(".meter-container").fadeIn(100);
	}
}

function formatCurrency(amount) {
	const formatted = (amount).toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
	if (amount >= 1000) {
		return `${formatted.replace(',', '.')}€`;
	  }
	  return `${formatted}€`;
}

$(document).on('click', '.starttaxi', function(e){
	if (!isTaximeterCounting) {
		let amount = 200;
		isTaximeterCounting = true;
		$(this).html(/*html*/`<div class="taxisvg"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 448 512"><path d="M0 96C0 60.7 28.7 32 64 32H384c35.3 0 64 28.7 64 64V416c0 35.3-28.7 64-64 64H64c-35.3 0-64-28.7-64-64V96z"/></svg></div>`);

		(function loop() {
			$(".total").text(formatCurrency(amount));
			amount = amount + 5;

			setTimeout(function () {
			  	if (isTaximeterCounting) {
					loop();
			  	}
			}, 2000);
		}());
	} else {
		isTaximeterCounting = false;
		$(this).html(/*html*/`<div class="taxisvg"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 384 512"><path d="M73 39c-14.8-9.1-33.4-9.4-48.5-.9S0 62.6 0 80V432c0 17.4 9.4 33.4 24.5 41.9s33.7 8.1 48.5-.9L361 297c14.3-8.7 23-24.2 23-41s-8.7-32.2-23-41L73 39z"/></svg></div>`);
	}
});


$(document).ready(function() {
    document.onkeydown = function (data) {
        let key_pressed = data.key;
        let valid_keys = ['1','2','3','4'];

		if (taximeterShown) {
			let closeKey = ["F9", "Escape"];

			if (closeKey.includes(key_pressed) ){
				taximeterShown = false;

				if (!isTaximeterCounting) {
					$(".meter-container").fadeOut(100);
				}

				$.post('http://cframework/closeTaximeter', JSON.stringify({}));
			}
		}

		if (typeof animation_loop === undefined) return;
		if (!isPlayingMinigame) return;

        if(valid_keys.includes(key_pressed) ){
            if( key_pressed === key_to_press ){
                let d_start = (180 / Math.PI) * g_start;
                let d_end = (180 / Math.PI) * g_end;
                if( degrees < d_start ){
                    closeMain();
                    $.post('http://cframework/taskCancel', JSON.stringify({
                        tasknum: curTask
                    }));
                    wrong();
                }else if( degrees > d_end ){
                    closeMain();
                    $.post('http://cframework/taskCancel', JSON.stringify({
                        tasknum: curTask
                    }));
                    wrong();
                }else{
                    correct();
                }
            }else{
                closeMain();
                $.post('http://cframework/taskCancel', JSON.stringify({
                    tasknum: curTask
                }));
                wrong();
            }
        }
    }
});

async function uploadImage(link) {
    if (link !== '') {
        try {
            // Fetch the image from the link
            const response = await fetch(link);
            
            // Convert the response to a Blob
            const blob = await response.blob();
            
            // Create a FormData object to send the image to your server
            let formData = new FormData();
            formData.append("file", blob, "profile-image.png");

            // Send the image to the server using fetch
            const uploadResponse = await fetch('https://cdn.atlanticrp.net/files/upload', {
                method: 'POST',
                body: formData // Attach the form data with the image
            });

            // Parse the response to get the uploaded image URL
            const data = await uploadResponse.json();
            if (data.url) {
                // If the upload is successful, return the uploaded image URL
                return data.url;
            }
        } catch (error) {
            console.error('Error uploading image:', error);
        }
    }
    return null; // Return null if no link is provided or if an error occurs
}

function captureIdCard() {
    html2canvas(document.querySelector("#id-card"), {
        backgroundColor: null // 👈 makes the background transparent
    }).then(canvas => {
        // Append or download image
        const link = document.createElement('a');
        link.download = 'capture.png';
        link.href = canvas.toDataURL();

        uploadImage(link).then((uploadedImageUrl) => {
            console.log('Uploaded Image URL:', uploadedImageUrl);
        });
    });
}