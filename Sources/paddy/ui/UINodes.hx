package paddy.ui;

import paddy.nodes.LogicNode;
import paddy.nodes.MathNode;
import paddy.nodes.VariableNode;
import paddy.nodes.StdNode;
import paddy.nodes.NodeCreator;
import zui.Id;
import zui.Zui;
import zui.Nodes;

@:access(zui.Zui)
class UINodes {

	public static var nodeHandle = Id.handle();
    public static var nodes: Nodes;

    public static var nodeCanvas:TNodeCanvas = {
		name: "My Nodes",
		nodes: [],
		links: []
	}

    public static function initNodes() {
        nodes = new Nodes();
    }
    
    public static function renderNodes(ui:Zui) {
		nodes.nodeCanvas(ui, nodeCanvas);
    }

	public static function renderNodesMenu(ui:Zui) {
		if(ui.window(nodeHandle, 200, 60, 150, 540)){
			if(ui.button("Export")){
				Krom.fileSaveBytes("nodes.json", haxe.io.Bytes.ofString(haxe.Json.stringify(nodeCanvas)).getData());
			}

			if(ui.panel(Id.handle(), "Logic")){
				if(ui.button("Gate")) nodeCanvas.nodes.push(NodeCreator.createNode(LogicNode.gate, nodes, nodeCanvas));
				ui.button("Branch");
				ui.button("Is False");
				ui.button("Is True");
				ui.button("Is Null");
				ui.button("While");
			}
			if(ui.panel(Id.handle(), "Variable")){
				if(ui.button("String")) nodeCanvas.nodes.push(NodeCreator.createNode(VariableNode.string, nodes, nodeCanvas));
				if(ui.button("Float")) nodeCanvas.nodes.push(NodeCreator.createNode(VariableNode.float, nodes, nodeCanvas));
				// ui.button("Array");
				if(ui.button("Boolean")) nodeCanvas.nodes.push(NodeCreator.createNode(VariableNode.boolean, nodes, nodeCanvas));
			}
			if(ui.panel(Id.handle(), "Std")){
				if(ui.button("Print")) nodeCanvas.nodes.push(NodeCreator.createNode(StdNode.print, nodes, nodeCanvas));
				if(ui.button("Parse Int")) nodeCanvas.nodes.push(NodeCreator.createNode(StdNode.parseInt, nodes, nodeCanvas));
				if(ui.button("Parse Float")) nodeCanvas.nodes.push(NodeCreator.createNode(StdNode.parseFloat, nodes, nodeCanvas));
				if(ui.button("Float To Int")) nodeCanvas.nodes.push(NodeCreator.createNode(StdNode.floatToInt, nodes, nodeCanvas));
			}
			if(ui.panel(Id.handle(), "Math")){
				if(ui.button("Maths")) nodeCanvas.nodes.push(NodeCreator.createNode(MathNode.maths, nodes, nodeCanvas));
				if(ui.button("Rad to Deg")) nodeCanvas.nodes.push(NodeCreator.createNode(MathNode.radtodeg, nodes, nodeCanvas));
				if(ui.button("Deg to Rad")) nodeCanvas.nodes.push(NodeCreator.createNode(MathNode.degtorad, nodes, nodeCanvas));
				if(ui.button("Random (Int)")) nodeCanvas.nodes.push(NodeCreator.createNode(MathNode.randi, nodes, nodeCanvas));
				if(ui.button("Random (Float)")) nodeCanvas.nodes.push(NodeCreator.createNode(MathNode.randf, nodes, nodeCanvas));
			}
			for (value in paddy.Plugin.plugins) if (value.nodeMenuUI != null) value.nodeMenuUI(ui);
		}
	}

}