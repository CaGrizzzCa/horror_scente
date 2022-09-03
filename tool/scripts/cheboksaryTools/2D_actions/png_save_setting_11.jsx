////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
var is_zz = IsNeedZzSettings(activeDocument);  // использовать настройки для ЗумЗоны                                                                      //
var is_unity = false;		                   // делает спрайты кратными 4                                                                               //
var is_trim_on = true;		                   // если false - у слоёв не обрезается альфа ( чтобы спрайты не смещались относительно центра "квадрата" )  //
var is_poloski = true;		                   // использование скрипта против белых полосок                                                              //
var is_groups_animation_roots = false;         // использование групп для корневых объектов в анимации                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
var userCancelled = false;
var userStarted = false;
var userDone = false;
var userCanceledDialog = false;

var userStart = false;
var userExit = false;

var doc = activeDocument;
oldRulerUnits = preferences.rulerUnits;
preferences.rulerUnits = Units.PIXELS;

var settingsDialog = createSettingsDialog()
settingsDialog.setingsRow.checkboxZz.value = is_zz;
settingsDialog.setingsRow.checkboxTrim.value = is_trim_on;
settingsDialog.setingsRow.checkboxPoloski.value = is_poloski;
settingsDialog.setingsRow.checkboxUnity.value = is_unity;
settingsDialog.setingsRow.checkboxGroups.value = is_groups_animation_roots;
settingsDialog.show();

var progressBarWindow

var positions = [];
var posObjs = [];
var sizeToResize = 2048;
var dpi = 72;
var width = doc.width;
var height = doc.height;

if ( userStart ){
	runActions();
}

//while ( !userStarted || !userDone ){
//	if( userCancelled )
//	{
//		exit( 0 );
//	}
//	$.sleep(250)
//}


//////////////////////////////////////////////////////////////////////////////
function runActions(){
	userCanceledDialog = false;
	is_zz                     = settingsDialog.setingsRow.checkboxZz.value;
	is_trim_on                = settingsDialog.setingsRow.checkboxTrim.value;
	is_poloski                = settingsDialog.setingsRow.checkboxPoloski.value;
	is_unity                  = settingsDialog.setingsRow.checkboxUnity.value;
	is_groups_animation_roots = settingsDialog.setingsRow.checkboxGroups.value;
	////-------------------загрузка-из-файла-строки-пути-----------------------------/////
		fileLineFeed = "windows";
		if ($.os.search(/windows/i) == -1)
			fileLineFeed = "macintosh";
			
		// check for old-directory; 
		var thePref = "~/Desktop/pngSaverOldPlace.txt";
		var theStoredInfo = thePref

		var fileSetings = new File(thePref)
		fileSetings.linefeed = fileLineFeed;
		if (fileSetings.exists == true) {
			if(fileSetings.open("r", "TEXT", "????") )
			{
				theStoredInfo = fileSetings.readln();
				fileSetings.close();
			}
			else
			{
				throw new Error('\n\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n Не удалось открыть файл ' + thePref + ' \n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n\n');
			}
		}
		
		var bool = "false"
		var objFolder = new Folder()
		var pfile = objFolder.selectDlg("SelectFolder:",theStoredInfo);
		
		if(pfile==null)
		{
			userCanceledDialog = true;
			//progressBarWindow.close();
			//exit( 0 );
			throw new Error('\n\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\nАдрес не указан - ВЫХОД\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n\n');
		}
		
		
		if (fileSetings.open("w", "TEXT", "????") )
		{
			fileSetings.writeln(pfile)
			fileSetings.close();
		}
	////////-----------------------------------------------------------------------///////////// 

	var stopFlag = true;
 
	var isZz = is_zz;

	if ( ( width>1366) && (height>768) & (!is_unity) )
	{
		stopFlag = false
		alert("Неверно задан размер холста!");
	}
	
	if (stopFlag) 
	{
		
		if( is_unity )
		{
			sizeToResize = 4086;
		}
		else if ( isZz )
		{
			sizeToResize = 1024;
		}
		
		setPositions( isZz );
		
		var prefix = ""//prompt("Input prefix:", "")
		
		var savedFiles = []
		var layersForSave = [];
		var docLayers = getLayers( activeDocument );

		// >> проверка повторяющихся имён >>
		for (var al = 0; al < docLayers.length; al++)
		{
			var layer = docLayers[al];
			if ( savedFiles[ layer.name ] == true ) {
				alert( "\n Слой с именем " + layer.name + " уже был сохранён ( дублируется имя слоя ) \n" );
					
					var messageLayers = "\n\n";
					for (var all = 0; all < savedFiles.length; all++)
					{
						messageLayers = messageLayers + "\n 1 >> " + savedFiles[ all ].name;
					}
					alert( "\n Обработанные слои("+savedFiles.length+") \n" + messageLayers );
				throw new Error( "\n Слой с именем " + layer.name + " уже был сохранён ( дублируется имя слоя ) \n" );
			}
			else
			{
				savedFiles[ layer.name ] = true;
				//savedFiles.push( layer.name )
				layersForSave.push( layer )
			}
		}
		var groupsForSave = [];
		if(is_groups_animation_roots)
		{
			var docGroups = getGroups( activeDocument )
			var savedGroups = []

			for (var al = 0; al < docGroups.length; al++)
			{
				var layer = docGroups[al];
				if ( savedGroups[ layer.name ] == true ) {
					
					var groupsMessage = "";
					for (var al = 0; al < docGroups.length; al++)
					{
						groupsMessage = groupsMessage + "\n" + docGroups[al].name;
					}
					
					alert( "\n 1 Группа с именем " + layer.name + " уже была сохранёна ( дублируется имя группы ) \n" )
					alert( "\n 3 groupsMessage \n\n" + groupsMessage );
					throw new Error( "\n 1 Группа с именем " + layer.name + " уже была сохранёна ( дублируется имя группы ) \n" )
				}
				else
				{
					savedGroups[ layer.name ] = true;
					groupsForSave.push( layer )
				}
			}
		}
		// << проверка повторяющихся имён <<
		
		// >> проверка на валидность имён >>
		var message = "Указано неверное имя слоя:"
		var badNames = false
		for (var layerID = 0; layerID < layersForSave.length; layerID++)
		{
			var layer = layersForSave[ layerID ];
			if (!checkLang (layer.name))
			{
				message += "\t'" + layer.name + "'(Layer)";
				badNames = true
			}
		}
		for (var layerID = 0; layerID < groupsForSave.length; layerID++)
		{
			var layer = groupsForSave[ layerID ];
			if (!checkLang (layer.name))
			{
				message += "\t'" + layer.name + "'(GROUP)";
				badNames = true
			}
		}
		if( badNames )
		{
			alert( message )
			throw new Error( message );
		}
		// << проверка на валидность имён <<
		
		// >> сохранение >>
		progressBarWindow = createProgressBar();
		showProgressBar( progressBarWindow, "Сохранение", layersForSave.length)
		for (var layerID = 0; layerID < layersForSave.length; layerID++)
		{
			var layer = layersForSave[ layerID ]
			if(userCancelled)
			{
				break;
			}
			updateProgressBar( progressBarWindow, "Сохранение (" + layerID + "/" + layersForSave.length + "): " + layer.name, layersForSave.length );
			saveLayer(layer, pfile, prefix, isZz);
		}
		progressBarWindow.close();
		// << сохранение <<

		////-------------------сохранение в файл------------------------------/////
			saveStringsArray( positions, pfile + '/position.txt' );
			if ( is_groups_animation_roots ) 
			{
				saveStringsArray( posObjs, pfile + '/position.pos' );
			}
		////////-----------------------------------------------------------------------/////////////

		preferences.rulerUnits = oldRulerUnits;
		
		userDone = true;
		//exit( 0 )
	}
}
//////////////////////////////////////////////////////////////////////////////
function IsNeedZzSettings( doc ) {
	var isZz = false
	if ((doc.width<=1366)&&(doc.height<=768))
	{
		if(((doc.width==1366)&&(doc.height==768)))
		{
			
		}
		else
		{
			isZz = true;
		}
	}
	return isZz
}
//////////////////////////////////////////////////////////////////////////////
function saveStringsArray( stringsArray, filePath ) {
	if ($.os.search(/windows/i) != -1)
				fileLineFeed = "windows";
	else
		fileLineFeed = "macintosh";
	
	var fileOut	= new File( filePath ); 
	// set linefeed
	fileOut.linefeed = fileLineFeed;
	// open for write
	fileOut.open( "w", "TEXT", "????" );              
	// write to file
	var str = "";
	for ( s = 0; s < stringsArray.length; s++ )
	{
		str += stringsArray[ s ];
	}
	fileOut.write( str );
	// close the file
	fileOut.close();
}
//////////////////////////////////////////////////////////////////////////////
function saveLayer(layer, pfile, prefix, isInZz){
	activeDocument = doc;
	
	if( is_trim_on )
	{
		//doc.resizeCanvas(width,height,AnchorPosition.MIDDLECENTER);
		if(layer.name == "back" || endsWith( layer.name, ".jpg" ) || endsWith( layer.name, ".bmp" ) )
		{
			DocResizeCanvas( doc, width, height, AnchorPosition.MIDDLECENTER )
		}
		else
		{
			DocResizeCanvas( doc, sizeToResize, sizeToResize, AnchorPosition.MIDDLECENTER )
		}
	}
    layer.copy();
	
    var docTo = documents.add(doc.width, doc.height, dpi, layer.name, NewDocumentMode.RGB, DocumentFill.TRANSPARENT);
	
    activeDocument = docTo;
	if( is_trim_on )
	{
		docTo.paste();
		docTo.trim(TrimType.TRANSPARENT);
	}
	else
	{
		pasteInPlace();
	}
    
	

	
	
	var fileName = "";
     ///---------------------------------------------------------------------------------------------///
	 
	 if(endsWith( layer.name, ".bmp" ) )
    {
		DocResize( docTo, false, false );
        fileName = pfile + "/" + prefix + layer.name;
		
		fileName = fileName.substring( 1 )
		var diskLetter = fileName.substring( 0, 1 )
		fileName = fileName.substring( 1 )
		fileName = diskLetter + ":" + fileName;
		
		fileName = fileName.replace(new RegExp("/", 'g'), "\\")
		
		bmpSaveOptions = new BMPSaveOptions();
		bmpSaveOptions.alphaChannels = false;
		bmpSaveOptions.depth = BMPDepthType.TWENTYFOUR;
		bmpSaveOptions.flipRowOrder = false;
		bmpSaveOptions.rleCompression = false;
		bmpSaveOptions.osType = OperatingSystem.WINDOWS;
		
		var file = new File( fileName )
		docTo.saveAs( file, bmpSaveOptions, true, Extension.LOWERCASE);
		docTo.close(SaveOptions.DONOTSAVECHANGES)
		file.close();
    }
	else
	{
		var sfw = new ExportOptionsSaveForWeb();
		sfw.quality = 100;
	
		if( layer.name == "back" && !is_unity )
		{
			fileName = pfile + "/" + prefix + layer.name + ".jpg";
			sfw.format = SaveDocumentType.JPEG;
			sfw.embedColorProfile = false;
		}
		else if(endsWith( layer.name, ".jpg" ) )
		{
			DocResize( docTo, false, false );
			fileName = pfile + "/" + prefix + layer.name;
			sfw.format = SaveDocumentType.JPEG;
			sfw.embedColorProfile = false;
		}
		else
		{
			DocResize( docTo, isInZz, is_poloski );
			fileName = pfile + "/" + prefix + layer.name + ".png";
			sfw.format = SaveDocumentType.PNG;
			sfw.PNG8 = false; // use PNG-24
			sfw.transparency = true;  
		}
		
		var file = new File(fileName)
		docTo.exportDocument( file, ExportType.SAVEFORWEB, sfw );
		docTo.close(SaveOptions.DONOTSAVECHANGES)
		file.close();
	}
	
}
//////////////////////////////////////////////////////////////////////////////
function DocResize( docTo, zzOptimization, poloski ){
	
	var wh_changed = false
	var w = docTo.width;
    if (w%2!=0)
	{
		w+=1;
		wh_changed=true;
	}
    var h = docTo.height;
    if (h%2!=0)
	{
		h+=1;
		wh_changed=true;
	}
	
	if( is_unity )
	{
		var checkp = 0;
		if( poloski )
		{
			checkp = 2
		}
		//-->> UNITY
		if (w%4!=checkp)
		{
			w+=2;
			wh_changed=true;
		}
		if (h%4!=checkp)
		{
			h+=2;
			wh_changed=true;
		}
		//--<< UNITY
	}
	
	if ( zzOptimization )
	{
		if ( w == 514 )
		{
			w = 512;
			wh_changed = true
		}
		if ( h == 514 )
		{
			h = 512
			wh_changed = true
		}
	}
	
	if(wh_changed)
	{
		DocResizeCanvas( docTo, w, h, AnchorPosition.MIDDLECENTER )
		wh_changed = false
	}
	
	if( poloski )
	{
		app.doAction('belie_poloski', 'POLOSKI')
	}
	
	if ( zzOptimization )
	{
		w = docTo.width;
		if ( w == 514 )
		{
			w = 512;
			wh_changed = true
		}
		h = docTo.height;
		if ( h == 514 )
		{
			h = 512
			wh_changed = true
		}
	}
	
	if(wh_changed)
	{
		DocResizeCanvas( docTo, w, h, AnchorPosition.MIDDLECENTER )
	}
}
//////////////////////////////////////////////////////////////////////////////
function DocResizeCanvas( doc, w, h, anchor ) {
	try {
		doc.resizeCanvas( w, h, anchor );
    } catch (e) {
		if (e.number == 8007) {      // User cancelled
			try {
				doc.resizeCanvas( w, h, anchor );
			} catch (e) {
				if (e.number != 8007) {      // User cancelled
					Error.runtimeError(9001, e.toString());
				}
			}
		} else {
			Error.runtimeError(9001, e.toString());
		}
	}
}
//////////////////////////////////////////////////////////////////////////////
function setPositions( inZz ) {
    //app.preferences.rulerUnits = Units.PIXELS;
	//var obj = app.activeDocument;
	var layers = getLayers( activeDocument )
	var coords;
	for( var i = 0; i<layers.length; i++) {
		var layer = layers[i];
        var coords = getCoord( layer, inZz ); 
		x = coords[ 1 ]; 
		y = coords[ 2 ];
		var layerSaveName = layer.name;
		if ( endsWith( layerSaveName, ".jpg" ) )
		{
			layerSaveName = layerSaveName.substring(0, layerSaveName.length - 4)
		}
		var str = layerSaveName + " " + x + " px " + y+" px\r" ;
		positions= positions +str +"\n";
	}
	
	if ( is_groups_animation_roots ) 
	{
		var layers_grouped = getLayers( activeDocument, true )
		
		var deep = 1;
		
		posObjs[ 0 ] = "<position>\r\n";
		
		setPositionsGrouped( inZz, layers_grouped, deep );
		
		posObjs.push( "</position>\r\n" );
	}
}
function setPositionsGrouped( inZz, layers_with_invisible, deep, layer_parent ) {
	var spaces = '';
	for ( s = 0; s < deep; s++ )
	{
		spaces += '  ';
	}

	var layers = []
	for( var iii = 0; iii < layers_with_invisible.length; iii++) {
		if(layers_with_invisible[iii].visible)
		{
			layers.push( layers_with_invisible[iii] );
		}
	}
	
	//alert( "setPositionsGrouped >> layers length = " + layers.length );
	
	for( var i = 0; i < layers.length; i++) {
		var layer = layers[i];
		var layerSaveName = layer.name;
		if ( endsWith( layerSaveName, ".jpg" ) )
		{
			layerSaveName = layerSaveName.substring(0, layerSaveName.length - 4)
		}
		if ( layer.typename == 'LayerSet' )
		{
			//alert( "setPositionsGrouped >> " + i + " >> Обработка группы >> " + layer.name );
			var objBegStr = spaces;
			var objEndStr = spaces;
			
			var child_layers = []
			for( var ii = 0; ii < layer.layers.length; ii++) {
				if(layer.layers[ii].visible)
				{
					child_layers.push( layer.layers[ii] );
				}
			}
			
			var next_layer_parent
			//>> имя группы совпадает с именем слоя >> корневой объект будет спрайтом
			if( child_layers[ child_layers.length - 1 ].name == layer.name )
			{
				var coords = getCoord( child_layers[ child_layers.length - 1 ], inZz ); 
				objBegStr += '<spr name="' + layerSaveName + '" pos_x="' + coords[ 1 ] + '" pos_y="' + coords[ 2 ] + '" res="' + layerSaveName + '">\r\n';
				objEndStr += '</spr>\r\n';
				next_layer_parent = layer;
			}
			else
			{
				objBegStr += '<obj name="' + layerSaveName + '">\r\n';
				objEndStr += '</obj>\r\n';
				next_layer_parent = null;
			}
			posObjs.push( objBegStr );
			setPositionsGrouped( inZz, child_layers, deep + 1, next_layer_parent )
			posObjs.push( objEndStr  );
		}
		else
		{
			//alert( "setPositionsGrouped >> " + i + " >> Обработка спрайта >> " + layer.name );
			if ( ( i == layers.length - 1 ) && ( layer_parent !== 'undefined' && layer_parent != null ) )
			{
				//>> родительский объект создан вместо этого
				//alert( "родительский объект создан вместо этого >> " + layer.name );
				//try {
				//	alert( "имя родительского объекта >> " + layer_parent.name );
				//}
				//catch (e) {
				//	alert("ошибка при получении родительской группы \n"+ e, "Error", true);
				//}
			}
			else if ( ( layer_parent !== 'undefined' && layer_parent != null ) && layer_parent.name == layer.name )
			{
				throw new Error( "\n найден СЛОЙ с именем ГРУППЫ >> " + layer.name + " >> такие слои должны быть последними в группе \n" );
			}
			else
			{
				var coords = getCoord( layer, inZz ); 
				var objStr = spaces + '<spr name="' + layerSaveName + '" pos_x="' + coords[ 1 ] + '" pos_y="' + coords[ 2 ] + '" res="' + layerSaveName + '" />\r\n';
				posObjs.push( objStr  );
			}
		}
	}
}
//////////////////////////////////////////////////////////////////////////////
function getLayers( layersDoc, grouped ) {
	var answer = new Array();
	var layers = layersDoc.layers;
	getLayersDeep( layers, answer, grouped );
	return answer;
}
function getLayersDeep( layers, answer, grouped ){
	for( var i=0; i< layers.length;i++){  
		if(layers[i].visible)
		{
			if(layers[i].typename == 'LayerSet'){  
				if(layers[i].layers.length>0){
					//alert( "getLayersDeep >> Обработка группы >> " + layers[i].name );
					if( grouped && grouped !== 'undefined' )
					{
						answer.push( layers[i] );
					}
					else
					{
						getLayersDeep( layers[i].layers, answer );
					}
				}  
			} else {
				answer.push( layers[i] );
			}    
		}
    };
}
function getGroups( layersDoc ) {
	var answer = new Array();
	var layers = layersDoc.layers;
	getGroupsDeep( layers, answer );
	return answer;
}
function getGroupsDeep( layers, answer ){
	for( var i=0; i< layers.length;i++){  
		if(layers[i].visible)
		{
			if(layers[i].typename == 'LayerSet'){  
				answer.push( layers[i] );
				if(layers[i].layers.length>0){
					getGroupsDeep( layers[i].layers, answer );
				}  
			}   
		}		
    };
}
//////////////////////////////////////////////////////////////////////////////
function getCoord( layer, inZz ) {
	
	var dx = app.activeDocument.height;
    var dy = app.activeDocument.width;
	
	var x = (layer.bounds[2] - layer.bounds[0]);
	if (x%2!=0) x+=1; ///вычисляет центр картинки
	x = x/2
	x += layer.bounds[0]
	
	var y = (layer.bounds[3] - layer.bounds[1])
	if (y%2!=0)y+=1;
	y = y/2;
	y += layer.bounds[1];
	
	if ( inZz )
	{
		x -= app.activeDocument.width / 2;
		y -= app.activeDocument.height / 2;
	}
	else
	{
		x -= 171;
	}
	
	x = Math.round( x ); 
	y = Math.round( y );

	var answer= [];
	answer[1] = x;
	answer[2] = y;
	return answer;
}
//////////////////////////////////////////////////////////////////////////////
function endsWith( str, suffix ) {
    return str.indexOf(suffix, str.length - suffix.length) !== -1;
}
//////////////////////////////////////////////////////////////////////////////
function checkLang(name){
	if ( endsWith( name,".jpg" ) || endsWith( name, ".bmp" ) )
	{
		name = name.substring(0, name.length - 4);
	}
    for (i = 0; i <name.length;i++){
        var ch = name.charCodeAt(i)
        if ((("a".charCodeAt(0)<=ch)&&(ch<="z".charCodeAt(0)))||(ch == "_".charCodeAt(0))||(("0".charCodeAt(0)<=ch)&&(ch<="9".charCodeAt(0))))
        {
        }
        else 
        {
            return false
        }
    } 
    return true
}
//////////////////////////////////////////////////////////////////////////////
function cTID(s) { return app.charIDToTypeID(s); };
function sTID(s) { return app.stringIDToTypeID(s); };
function pasteInPlace(enabled, withDialog) {
    if (enabled != undefined && !enabled)
      return;
    var dialogMode = (withDialog ? DialogModes.ALL : DialogModes.NO);
    var desc1 = new ActionDescriptor();
    desc1.putBoolean(sTID("inPlace"), true);
    desc1.putEnumerated(cTID('AntA'), cTID('Annt'), cTID('Anno'));
    executeAction(cTID('past'), desc1, dialogMode);
};
//////////////////////////////////////////////////////////////////////////////
function createProgressBar(){
	// read progress bar resource

	const windowString = "palette { \
		text: 'Please wait...', \
		preferredSize: [350, 60], \
		orientation: 'column', \
		alignChildren: 'fill', \
		barRow: Group { \
			orientation: 'row', \
			bar: Progressbar { \
				preferredSize: [300, 16] \
			}, \
			actionBtn: Button { \
				text: 'Start' \
			} \
		}, \
		lblMessage: StaticText { \
			preferredSize: [300, 16], \
			alignment: 'left', \
			text: '' \
		}, \
		warning: Panel { \
			orientation: 'column', \
			alignChildren: 'fill', \
			message: StaticText { \
				text: 'Don`t make changes to the current document while the script is running!', \
				properties: { \
					multiline: true \
				} \
			} \
		} \
	}";


	// create window
	var win;
	try {
		win = new Window( windowString );
	}
	catch (e) {
		alert("Progress bar resource is corrupt! Please, contact your programmers \n"+ e, "Error", true);
		return false;
	}

	win.barRow.actionBtn.onClick = function() {
		userCancelled = true;
	};

	win.onResizing = win.onResize = function () {
		this.layout.resize();
	}

	win.onClose = function() {
		userCancelled = true;
		return false;
	};
	return win;
}
function showProgressBar(win, message, maxValue){
	win.lblMessage.text = message;
	win.barRow.bar.maxvalue = maxValue;
	win.barRow.bar.value = 0;

	win.center();
	win.show();
	repaintProgressBar(win, true);
}
function updateProgressBar(win, message, maxValue){
	win.barRow.bar.maxvalue = maxValue;
	++win.barRow.bar.value;
	if (message) {
		win.lblMessage.text = message;
	}
	
}
function repaintProgressBar(win, force /* = false*/){
	if (app.version >= 11) {	// CS4 added support for UI updates; the previous method became unbearably slow, as is app.refresh()
		if (force) {
			app.refresh();
		}
		else {
			win.update();
		}
	}
	else {
		// CS3 and below
		var d = new ActionDescriptor();
		d.putEnumerated(app.stringIDToTypeID('state'), app.stringIDToTypeID('state'), app.stringIDToTypeID('redrawComplete'));
		app.executeAction(app.stringIDToTypeID('wait'), d, DialogModes.NO);
	}
}
//////////////////////////////////////////////////////////////////////////////
function createSettingsDialog(){
	// read progress bar resource

	const windowString = "dialog { \
		text: 'Settings', \
		preferredSize: [384, 128], \
		orientation: 'column', \
		alignChildren: 'fill', \
		setingsRow: Group { \
			orientation: 'column', \
			checkboxZz: Checkbox { \
				preferredSize: [64, 16], \
				text: 'использовать настройки для ЗумЗоны  ', \
				alignment: 'left', \
				value: true \
			}, \
			checkboxPoloski: Checkbox { \
				preferredSize: [64, 16], \
				text: 'Использовать скрипт против полосок', \
				alignment: 'left', \
				value: true \
			}, \
			checkboxTrim: Checkbox { \
				preferredSize: [64, 16], \
				text: 'Обрезать лишнюю альфу', \
				alignment: 'left', \
				value: true \
			}, \
			checkboxUnity: Checkbox { \
				preferredSize: [64, 16], \
				text: 'Использовать настройки для юнити', \
				alignment: 'left', \
				value: false \
			}, \
			checkboxGroups: Checkbox { \
				preferredSize: [64, 16], \
				text: 'Использовать группы для корневых объектов в анимации', \
				alignment: 'left', \
				value: false \
			} \
		}, \
		barRow: Group { \
			buttonStart: Button { \
				text: 'Start' \
			}, \
			orientation: 'row', \
			buttonExit: Button { \
				text: 'Exit' \
			} \
		} \
	}";


	// create window
	var win;
	try {
		win = new Window( windowString );
	}
	catch (e) {
		alert("SettingsDialog resource is corrupt! Please, contact your programmers \n"+ e, "Error", true);
		return false;
	}

	win.barRow.buttonStart.onClick = function() {
		userStart = true;
		win.close();
		return true;
	};
	
	win.barRow.buttonExit.onClick = function() {
		userExit = true;
		win.close();
		return false;
	};

	win.setingsRow.checkboxUnity.onClick  = function() {
		if( win.setingsRow.checkboxUnity.value == true )
		{
			win.setingsRow.checkboxZz.value = true;
		}
		else
		{
			win.setingsRow.checkboxZz.value = IsNeedZzSettings(activeDocument);
		}
	};
	
	win.setingsRow.checkboxZz.onClick  = function() {
		if( win.setingsRow.checkboxZz.value == true )
		{
			
		}
		else
		{
			win.setingsRow.checkboxUnity.value = false;
		}
	};
	
	win.onResizing = win.onResize = function () {
		this.layout.resize();
	}

	return win;
}