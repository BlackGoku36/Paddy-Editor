let plug = new paddy.Plugin();

var defines = ["project.addDefine('rice_debug');"];
var shaderDefines = [];
var postprocess = false;

var targetCommand = "";
var targetRunCommand = "";

var khaPath = "";
var kromPath = "";
var rice2dPath = "";
var zuiPath = "";

var options = ["Run (Rice2D)", "Clean builds (Rice2D)"];
paddy.App.buildOptions.push(...options);

function exportScene() {
	var clonedScene = JSON.parse(JSON.stringify(paddy.App.scene));
	for (asset of clonedScene.assets) {
		var path = "" + asset.path;
		asset.path = path.split("/")[1];
		asset.name = paddy.Path.getNameFromPath(asset.name, false);
	}
	for (obj of clonedScene.objects) {
		obj.spriteRef = paddy.Path.getNameFromPath(obj.spriteRef, false);
		for(scr of obj.scripts){
			scr.scriptRef = paddy.Path.getNameFromPath(scr.scriptRef, true);
		}
	}
	for(scr of clonedScene.scripts){
		scr.scriptRef = paddy.Path.getNameFromPath(scr.scriptRef, true);
	}
	return clonedScene;
}

var khaPathHandle = new zui.Handle();
var kromPathHandle = new zui.Handle();
var rice2dPathHandle = new zui.Handle();
var zuiPathHandle = new zui.Handle();
var pathsHandle = new zui.Handle();

var targetsHandle = new zui.Handle({selected:true});
var targetCmb = new zui.Handle({position:0});

var configPanelHandle = new zui.Handle();

var postprocessPanelHandle = new zui.Handle();
var chromaticAbbHandle = new zui.Handle();
var vignetteHandle = new zui.Handle();

function reloadConfig() {
	kha.Assets.loadBlobFromPath("plugins/rice_config.json", function(blob){
		var config = JSON.parse(blob.toString());
		khaPathHandle.text = config.khaPath;
		kromPathHandle.text = config.kromPath;
		rice2dPathHandle.text = config.rice2dPath;
		zuiPathHandle.text = config.zuiPath;
	});
}

plug.onInit = function(){
	reloadConfig();
}


plug.outlinerWinUI = function (ui) {
	var projectPath = paddy.App.projectPath;
	var projectName = paddy.App.paddydata.name;
	
	if (ui.tab(paddy.UIOutliner.outlinerTab, "Rice2D")) {
		if(ui.panel(configPanelHandle, "Configuration")){
			if(ui.button("Re-load Config")){
				reloadConfig();
			}
			if(ui.button("Save Config")){
				paddy.Export.exportJsonFile("Assets/plugins/rice_config.json", JSON.parse(`{"khaPath":"${khaPath}", "kromPath":"${kromPath}", "rice2dPath":"${rice2dPath}", "zuiPath":"${zuiPath}"}`));
			}
		}
		if(ui.panel(pathsHandle, "Paths")){
			ui.indent();
			ui.row([1/5, 3/5, 1/5]);
			ui.text("Rice2D");
			rice2dPath = ui.textInput(rice2dPathHandle, "");
			if(ui.button("/\\")){
				paddy.App.showFileBrowser = true;
				paddy.UIFileBrowser.onDone = function(path){
					rice2dPathHandle.text = path;
				}
			}
			ui.row([1/5, 3/5, 1/5]);
			ui.text("Zui");
			zuiPath = ui.textInput(zuiPathHandle, "");
			if(ui.button("/\\")){
				paddy.App.showFileBrowser = true;
				paddy.UIFileBrowser.onDone = function(path){
					zuiPathHandle.text = path;
				}
			}
			ui.row([1/5, 3/5, 1/5]);
			ui.text("Kha");
			khaPath = ui.textInput(khaPathHandle, "");
			if(ui.button("/\\")){
				paddy.App.showFileBrowser = true;
				paddy.UIFileBrowser.onDone = function(path){
					khaPathHandle.text = path;
				}
			}
			ui.row([1/5, 3/5, 1/5]);
			ui.text("Krom");
			kromPath = ui.textInput(kromPathHandle, "");
			if(ui.button("/\\")){
				paddy.App.showFileBrowser = true;
				paddy.UIFileBrowser.onDone = function(path){
					kromPathHandle.text = path;
				}
			}
			ui.unindent();
		}
		
		if(ui.panel(targetsHandle, "Target")){
			ui.indent();
			var target = ui.combo(targetCmb, ["Krom", "Html-5", "Native"]);
			if(target == 0){
				targetCommand = `cd ${projectPath}/${projectName}; node ${khaPath}/make krom`;
				targetRunCommand = `${kromPath} ${projectPath}/${projectName}/build/krom ${projectPath}/${projectName}/build/krom-resources`;
			}else if(target == 1){
				targetCommand = `cd ${projectPath}/${projectName}; node ${khaPath}/make html5`;
			}else if(target == 2){
				targetCommand = `cd ${projectPath}/${projectName}; node ${khaPath}/make --run`;
				targetRunCommand = `echo 'running...'`;
			}else{}
			ui.unindent();
		}
		
		if(ui.panel(postprocessPanelHandle, "Post-Process")){

			ui.check(vignetteHandle, "Vignette");
			ui.check(chromaticAbbHandle, "Chromatic Abberation");
			
			if(vignetteHandle.selected || chromaticAbbHandle.selected){
				postprocess = true;
				defines[1] = "project.addDefine('rice_postprocess');";
			}else{
				postprocess = false;
				defines[1] = "";
			}
			
			(vignetteHandle.selected) ? shaderDefines[0] = "'vignette'" : shaderDefines[0] = "'decoy'";
			(chromaticAbbHandle.selected) ? shaderDefines[1] = "'chromatic_abberation'" : shaderDefines[1] = "'decoy'";

		}
	}
}

plug.onRemove = function () {
	paddy.App.modeComboHandle.position = 0;
	paddy.App.buildOptions = paddy.App.buildOptions.filter(item => !options.includes(item));
}

var eventNodeHandle = new zui.Handle();
var inputNodeHandle = new zui.Handle();
var mathNodeHandle = new zui.Handle();
var transformNodeHandle = new zui.Handle();
var nodeTabHandle = paddy.UINodes.nodeTabHandle;

plug.nodeMenuUI = function (ui) {
	if(ui.tab(nodeTabHandle, "Rice2D")){
		if (ui.panel(eventNodeHandle, "Event")) {
			if (ui.button("On Init")) paddy.UINodes.pushNodeToSelectedGroup(onInitNode);
			if (ui.button("On Update")) paddy.UINodes.pushNodeToSelectedGroup(onUpdateNode);
		}
		if (ui.panel(inputNodeHandle, "Input")) {
			if (ui.button("On Mouse")) paddy.UINodes.pushNodeToSelectedGroup(onMouseNode);
			if (ui.button("Mouse Coord")) paddy.UINodes.pushNodeToSelectedGroup(mouseCoordNode);
			if (ui.button("On Keyboard")) paddy.UINodes.pushNodeToSelectedGroup(onKeyboardNode);
		}
		if (ui.panel(mathNodeHandle, "Math")) {
			if (ui.button("Split Vec2")) paddy.UINodes.pushNodeToSelectedGroup(splitVec2Node);
			if (ui.button("Join Vec2")) paddy.UINodes.pushNodeToSelectedGroup(joinVec2Node);
		}
		if (ui.panel(transformNodeHandle, "Transform")) {
			if (ui.button("Set Object Loc")) paddy.UINodes.pushNodeToSelectedGroup(setObjectLocNode);
			if (ui.button("Translate Object")) paddy.UINodes.pushNodeToSelectedGroup(translateObjectNode);
		}
	}
}

let onInitNode = {id:0,name:"On Init",type:"InitNode",x:200,y:200,inputs:[],outputs:[{id:0,node_id:0,name:"Out",type:"ACTION",color:0xffaa4444,default_value:""}],buttons:[],color:-4962746};
let onUpdateNode = {id:0,name:"On Update",type:"UpdateNode",x:200,y:200,inputs:[],outputs:[{id:0,node_id:0,name:"Out",type:"ACTION",color:0xffaa4444,default_value:""}],buttons:[],color:-4962746};
let onMouseNode = {id:0,name:"On Mouse",type:"OnMouseNode",x:200,y:200,inputs:[],outputs:[{id:0,node_id:0,name:"Out",type:"ACTION",color:0xffaa4444,default_value:""}],buttons:[{name:"operations1",type:"ENUM",data:["Started","Down","Release","Moved"],output:0,default_value:0},{name:"operations2",type:"ENUM",data:["Left","Middle","Right"],output:0,default_value:0}],color:-4962746};
let mouseCoordNode = {id:0,name:"Mouse Coord",type:"MouseCoordNode",x:200,y:200,inputs:[],outputs:[{id:0,node_id:0,name:"Position",type:"VECTOR2",color:-7929601,default_value:""},{id:0,node_id:0,name:"Movement",type:"VECTOR2",color:-7929601,default_value:""},{id:0,node_id:0,name:"Wheel Delta",type:"VALUE",color:-10183681,default_value:""}],buttons:[],color:-4962746};
let setObjectLocNode = {id:0,name:"Set Object Location",type:"SetObjLocNode",x:200,y:200,color:-4962746,inputs:[{id:0,node_id:0,name:"In",type:"ACTION",color:0xffaa4444,default_value:""},{id:0,node_id:0,name:"Object",type:"STRING",color:-4934476,default_value:""},{id:0,node_id:0,name:"Vec2",type:"VECTOR2",color:-7929601,default_value:new kha.FastVector2(0.0, 0.0)}],outputs:[{id:0,node_id:0,name:"Out",type:"ACTION",color:0xffaa4444,default_value:""}],buttons:[]};
let splitVec2Node = {id:0,name:"Split Vec2",type:"SplitVec2Node",x:200,y:200,color:-4962746,inputs:[{id:0,node_id:0,name:"Vec2",type:"VECTOR2",color:-7929601,default_value:[0.0,0.0]}],outputs:[{id:0,node_id:0,name:"X",type:"VALUE",color:-10183681,default_value:0.0},{id:1,node_id:0,name:"Y",type:"VALUE",color:-10183681,default_value:0.0}],buttons:[]};
let translateObjectNode = {id:0,name:"Translate Object",type:"TranslateObjectNode",x:200,y:200,color:-4962746,inputs:[{id:0,node_id:0,name:"In",type:"ACTION",color:0xffaa4444,default_value:""},{id:0,node_id:0,name:"Object",type:"STRING",color:-4934476,default_value:""},{id:0,node_id:0,name:"Vec2",type:"VECTOR2",color:-7929601,default_value:new kha.FastVector2(0.0,0.0)},{id:0,node_id:0,name:"Speed",type:"VALUE",color:-10183681,default_value:1.0}],outputs:[{id:0,node_id:0,name:"Out",type:"ACTION",color:0xffaa4444,default_value:""}],buttons:[]};
let joinVec2Node = {id:0,name:"Join Vec2",type:"JoinVec2Node",x:200,y:200,color:-4962746,inputs:[{id:0,node_id:0,name:"X",type:"VALUE",color:-10183681,default_value:0.0},{id:0,node_id:0,name:"Y",type:"VALUE",color:-10183681,default_value:0.0}],outputs:[{id:0,node_id:0,name:"Vec2",type:"VECTOR2",color:-7929601,default_value:[0.0,0.0]}],buttons:[]};
let onKeyboardNode = {id:0,name:"On Keyboard",type:"OnKeyboardNode",x:200,y:200,inputs:[],outputs:[{id:0,node_id:0,name:"Out",type:"ACTION",color:0xffaa4444,default_value:""}],buttons:[{name:"operations1",type:"ENUM",data:["Started","Down","Release"],output:0,default_value:0},{name:"operations2",type:"ENUM",data:["Up","Down","Left","Right","Space","Return","Shift","Tab","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"],output:0,default_value:0}],color:-4962746};


plug.executeRunUI = function () {
	var khafile = `let project = new Project('New Project');\nproject.addAssets('Assets/**');\nproject.addShaders('Shaders/**',{defines:[${shaderDefines}]});\nproject.addSources('Sources');\nproject.addLibrary('${rice2dPath}');\nproject.addLibrary('${zuiPath}');\n${defines.join("")}\nproject.addParameter('rice2d.node');\nproject.addParameter('scripts');\nproject.addParameter('--macro keep(\"scripts\")');\nresolve(project);`;
	var main = "package;\nimport rice2d.App;\nclass Main {\npublic static function main() {\nnew App(\"scene\");\n}\n}";
	var projectPath = paddy.App.projectPath;
	var projectName = paddy.App.paddydata.name;
	var post_process = "#version 450\nuniform sampler2D tex;\nin vec2 texCoord;\nin vec4 color;\nout vec4 FragColor;\n#ifdef tonemap_reinhard\nvec3 tonemapReinhard(const vec3 color) {\nreturn color(colorvec3(1.0));\n}\n#endif\n#ifdef tonemap_uncharted2\nvec3 uncharted2Tonemap(const vec3 x) {\nconst float A0.15;\nconst float B0.50;\nconst float C0.10;\nconst float D0.20;\nconst float E0.02;\nconst float F0.30;\nreturn ((x(AxCB)DE)(x(AxB)DF)) - EF;\n}\nvec3 tonemapUncharted2(const vec3 color) {\nconst float W11.2;\nconst float exposureBias2.0;\nvec3 curruncharted2Tonemap(exposureBiascolor);\nvec3 whiteScale1.0uncharted2Tonemap(vec3(W));\nreturn curr*whiteScale;\n}\n#endif\n#ifdef tonemap_acesfilm\nvec3 tonemapAcesFilm(const vec3 x) {\nconst float a2.51;\nconst float b=0.03;\nconst float c=2.43;\nconst float d=0.59;\nconst float e=0.14;\nreturn clamp((x*(a*x+b))/(x*(c*x+d)+e),0.0,1.0);\n}\n#endif\nvoid main(){\nvec4 texcolor=texture(tex,texCoord)*color;\ntexcolor.rgb*=color.a;\n#ifdef chromatic_abberation\nconst float chAbb_strength=0.005;\nfloat rcolor=texture(tex,vec2(texCoord.x+chAbb_strength,texCoord.y)).r;\nfloat bcolor=texture(tex,vec2(texCoord.x-chAbb_strength,texCoord.y)).b;\ntexcolor.r=rcolor;\ntexcolor.b=bcolor;\n#endif\n#ifdef tonemap_reinhard\ntexcolor=vec4(tonemapReinhard(texcolor.rgb),texcolor.a);\n#elif tonemap_uncharted2\ntexcolor=vec4(tonemapUncharted2(texcolor.rgb),texcolor.a);\n#elif tonemap_acesfilm\ntexcolor=vec4(tonemapAcesFilm(texcolor.rgb),texcolor.a);\n#endif\n#ifdef vignette\nconst float vig_strength=1.5;\ntexcolor.rgb*=(1.0-vig_strength)+vig_strength*pow(15.0*texCoord.x*texCoord.y*(1.0-texCoord.x)*(1.0-texCoord.y),0.2);\n#endif\n#ifdef decoy\n#endif\nFragColor=texcolor;\n}\n";
	if(projectPath != ""){
		if (paddy.App.buildMode == paddy.App.buildOptions.indexOf("Run (Rice2D)")) {
			kha.TKrom.sysCommand(`mkdir ${projectPath}/${projectName}`);
			kha.TKrom.sysCommand(`mkdir ${projectPath}/${projectName}/Sources`);
			kha.TKrom.sysCommand(`mkdir ${projectPath}/${projectName}/Sources/scripts`);
			kha.TKrom.sysCommand(`mkdir ${projectPath}/${projectName}/Assets`);
			kha.TKrom.sysCommand(`mkdir ${projectPath}/${projectName}/Shaders`);
			paddy.Export.copyAssets(`${projectPath}${projectName}/Assets`);
			kha.TKrom.sysCommand(`echo '${projectPath}${projectName}/Assets'`);
			kha.TKrom.sysCommand(`cp Assets/mainfont.ttf ${projectPath}/${projectName}/Assets/mainfont.ttf`);
			paddy.Export.exportJsonFile(projectPath + "/" + projectName + "/Assets/scene.json", exportScene());
			paddy.Export.exportWindow(`${projectPath}/${projectName}/Assets`);
			paddy.Export.exportNodes(`${projectPath}/${projectName}/Assets`);
			paddy.Export.exportFile(`${projectPath}/${projectName}/khafile.js`, khafile);
			paddy.Export.exportFile(`${projectPath}/${projectName}/Sources/Main.hx`, main);
			if(postprocess) paddy.Export.exportFile(`${projectPath}/${projectName}/Shaders/postprocess.frag.glsl`, post_process);
			kha.TKrom.sysCommand(targetCommand);
			kha.TKrom.sysCommand(targetRunCommand);
		}else if (paddy.App.buildMode == paddy.App.buildOptions.indexOf("Clean builds (Rice2D)")){
			if(paddy.App.platform != "windows"){
				kha.TKrom.sysCommand(`rm -r '${projectPath}/${projectName}/build'`);
			}else{
				kha.TKrom.sysCommand(`rmdir /Q /S "${projectPath}/${projectName}/build"`);
			}
		}
	}else{
		kha.TKrom.sysCommand(`echo 'Error: Can't find project path, consider saving the project first.'`);
	}
}