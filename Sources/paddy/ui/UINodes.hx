package paddy.ui;

import kha.Color;
import paddy.data.Data.NodeData;
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

	public static var nodesArray: Array<NodeData> = [];
	public static var selectedNode:NodeData = null;

	public static var nodeHandle = Id.handle();
    
    public static function renderNodes(ui:Zui) {
		if(selectedNode != null) selectedNode.nodes.nodeCanvas(ui, selectedNode.nodeCanvas);
    }

	public static function renderNodesMenu(ui:Zui) {
		if(selectedNode == null) return;

		if(ui.window(nodeHandle, 200, 60, 150, 540)){
			// trace(Color.fromBytes(50, 50, 200));

			if(ui.panel(Id.handle(), "Logic")){
				if(ui.button("Gate")) selectedNode.nodeCanvas.nodes.push(NodeCreator.createNode(LogicNode.gate, selectedNode.nodes, selectedNode.nodeCanvas));
				ui.button("Branch");
				ui.button("Is False");
				ui.button("Is True");
				ui.button("Is Null");
				ui.button("While");
			}
			if(ui.panel(Id.handle(), "Variable")){
				if(ui.button("String")) selectedNode.nodeCanvas.nodes.push(NodeCreator.createNode(VariableNode.string, selectedNode.nodes, selectedNode.nodeCanvas));
				if(ui.button("Float")) selectedNode.nodeCanvas.nodes.push(NodeCreator.createNode(VariableNode.float, selectedNode.nodes, selectedNode.nodeCanvas));
				if(ui.button("Int")) selectedNode.nodeCanvas.nodes.push(NodeCreator.createNode(VariableNode.int, selectedNode.nodes, selectedNode.nodeCanvas));
				// ui.button("Array");
				if(ui.button("Boolean")) selectedNode.nodeCanvas.nodes.push(NodeCreator.createNode(VariableNode.boolean, selectedNode.nodes, selectedNode.nodeCanvas));
			}
			if(ui.panel(Id.handle(), "Std")){
				if(ui.button("Print")) selectedNode.nodeCanvas.nodes.push(NodeCreator.createNode(StdNode.print, selectedNode.nodes, selectedNode.nodeCanvas));
				if(ui.button("Parse Int")) selectedNode.nodeCanvas.nodes.push(NodeCreator.createNode(StdNode.parseInt, selectedNode.nodes, selectedNode.nodeCanvas));
				if(ui.button("Parse Float")) selectedNode.nodeCanvas.nodes.push(NodeCreator.createNode(StdNode.parseFloat, selectedNode.nodes, selectedNode.nodeCanvas));
				if(ui.button("Float To Int")) selectedNode.nodeCanvas.nodes.push(NodeCreator.createNode(StdNode.floatToInt, selectedNode.nodes, selectedNode.nodeCanvas));
			}
			if(ui.panel(Id.handle(), "Math")){
				if(ui.button("Maths")) selectedNode.nodeCanvas.nodes.push(NodeCreator.createNode(MathNode.maths, selectedNode.nodes, selectedNode.nodeCanvas));
				if(ui.button("Rad to Deg")) selectedNode.nodeCanvas.nodes.push(NodeCreator.createNode(MathNode.radtodeg, selectedNode.nodes, selectedNode.nodeCanvas));
				if(ui.button("Deg to Rad")) selectedNode.nodeCanvas.nodes.push(NodeCreator.createNode(MathNode.degtorad, selectedNode.nodes, selectedNode.nodeCanvas));
				if(ui.button("Random (Int)")) selectedNode.nodeCanvas.nodes.push(NodeCreator.createNode(MathNode.randi, selectedNode.nodes, selectedNode.nodeCanvas));
				if(ui.button("Random (Float)")) selectedNode.nodeCanvas.nodes.push(NodeCreator.createNode(MathNode.randf, selectedNode.nodes, selectedNode.nodeCanvas));
			}
			for (value in paddy.Plugin.plugins) if (value.nodeMenuUI != null) value.nodeMenuUI(ui);
		}
	}

	public static function getNodesArrayNames() {
		var names = [];
		for (nodes in nodesArray) names.push(nodes.name);
		return names;
	}

}