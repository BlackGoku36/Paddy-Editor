

//New plugin instance

let plug = new paddy.Plugin();



//Add new build option

paddy.App.buildOptions.push("Test");



// This runs when '=>' button is pressed (next to build options)

plug.executeRunUI = function () {

	// Path to project file (project need to be save)

	var path = paddy.App.projectPath;

	if (path != "" && paddy.App.buildMode == paddy.App.buildOptions.indexOf("Test")) {

		//Tell Krom to run system command

		kha.TKrom.sysCommand(`echo 'Yeah! It worked!' > ${path}/test.txt`);

	}

}



// This runs when plugin is removed from plugin tab.

plug.onRemove = function () {

	// Here we remove Test build option.

	paddy.App.modeComboHandle.position = 0;

	var index = paddy.App.buildOptions.indexOf("Test");

	if (index > -1) {

		paddy.App.buildOptions.splice(index, 1);

	}

}



//Zui handels

let panelHandle = new zui.Handle();

let customNodeHandle = new zui.Handle();



plug.outlinerWinUI = function (ui) {

	// paddy.UIOutliner.outlinerTab is Outliner's tab handle

	if (ui.tab(paddy.UIOutliner.outlinerTab, "Test")) {

		if (ui.panel(panelHandle, "Panel 1")) {

			ui.indent();

			ui.text("Text 1");

			if (ui.button("Button 1")) ui.text("Button 1 pressed!");

			ui.unindent();

		}

		if (ui.panel(customNodeHandle, "Custom Nodes")) {

			// push node to selected node group

			if (ui.button("On Init")) paddy.UINodes.pushNodeToSelectedGroup(initNode);

			if (ui.button("On Update")) paddy.UINodes.pushNodeToSelectedGroup(updateNode);

		}

	}

}

//A node structure.

// Check Zui's node full structure: https://github.com/armory3d/zui/blob/b1d362dc92017363e228cd8e580acb0a90f33de9/Sources/zui/Nodes.hx#L749

let initNode = {

	id: 0,

	name: "On Init",

	type: "InitNode",

	x: 200,

	y: 200,

	inputs: [],

	outputs: [

		{

			id: 0,

			node_id: 0,

			name: "Out",

			type: "ACTION",

			color: 0xffaa4444,

			default_value: ""

		}

	],

	buttons: [],

	color: -4962746

}



let updateNode = {

	id: 0,

	name: "On Update",

	type: "UpdateNode",

	x: 200,

	y: 200,

	inputs: [],

	outputs: [

		{

			id: 0,

			node_id: 0,

			name: "Out",

			type: "ACTION",

			color: 0xffaa4444,

			default_value: ""

		}

	],

	buttons: [],

	color: -4962746

}
