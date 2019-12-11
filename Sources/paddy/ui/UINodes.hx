package paddy.ui;

import paddy.nodes.MathsNode;
import paddy.nodes.NodeCreator;
import zui.Id;
import zui.Zui;
import zui.Nodes;

@:access(zui.Zui)
class UINodes {

    public static var nodes: Nodes;

    static var nodeCanvas:TNodeCanvas = {
		name: "My Nodes",
		nodes: [
			{
				id: 0,
				name: "Node 1",
				type: "VALUE",
				x: 100,
				y: 100,
				color: 0xffaa4444,
				inputs: [],
				outputs: [
					{
						id: 0,
						node_id: 0,
						name: "Output",
						type: "VALUE",
						default_value: 0.0,
						color: 0xff44aa44
					}
				],
				buttons: []
			},
			{
				id: 1,
				name: "Node 2",
				type: "VALUE",
				x: 300,
				y: 100,
				color: 0xff4444aa,
				inputs: [
					{
						id: 0,
						node_id: 1,
						name: "Input",
						type: "VALUE",
						default_value: 0.0,
						color: 0xff44aa44
					}
				],
				outputs: [],
				buttons: []
			}
		],
		links: [
			{
				id: 0,
				from_id: 0,
				from_socket: 0,
				to_id: 1,
				to_socket: 0
			}
		]
	}

    public static function initNodes() {
        nodes = new Nodes();
    }
    
    public static function renderNodes(ui:Zui) {
		nodes.nodeCanvas(ui, nodeCanvas);
    }

	public static function renderNodesMenu(ui:Zui) {
		if(ui.window(Id.handle(), 200, 60, 150, 540)){

			if(ui.panel(Id.handle(), "Logic")){
				ui.button("Gate");
				ui.button("Branch");
				ui.button("Is False");
				ui.button("Is True");
				ui.button("Is Null");
				ui.button("While");
			}
			if(ui.panel(Id.handle(), "Variable")){
				ui.button("String");
				ui.button("Float");
				ui.button("Int");
				ui.button("Array");
				ui.button("Bool");
			}
			if(ui.panel(Id.handle(), "Std")){
				ui.button("Parse Int");
				ui.button("Parse Float");
				ui.button("Float To Int");
			}
			if(ui.panel(Id.handle(), "Math")){
				if(ui.button("Maths")) nodeCanvas.nodes.push(NodeCreator.createNode(MathsNode.maths, nodes, nodeCanvas));
				ui.button("Rad to Deg");
				ui.button("Deg to Rad");
				ui.button("Random (Int)");
				ui.button("Random (Float)");
				ui.button("Random (Color)");
			}
		}
	}

}