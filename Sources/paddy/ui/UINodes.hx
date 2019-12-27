package paddy.ui;

//Kha
import kha.Color;

//Zui
import zui.Id;
import zui.Zui;
import zui.Nodes;

//Editor
import paddy.data.Data.NodeData;
import paddy.nodes.StdNode;
import paddy.nodes.MathNode;
import paddy.nodes.LogicNode;
import paddy.nodes.NodeCreator;
import paddy.nodes.VariableNode;

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

			if(ui.panel(Id.handle(), "Logic")){
				if(ui.button("Gate")) pushNodeToSelectedGroup(LogicNode.gate);
				ui.button("Branch");
				ui.button("Is False");
				ui.button("Is True");
				ui.button("Is Null");
				ui.button("While");
			}
			if(ui.panel(Id.handle(), "Variable")){
				if(ui.button("String")) pushNodeToSelectedGroup(VariableNode.string);
				if(ui.button("Float")) pushNodeToSelectedGroup(VariableNode.float);
				if(ui.button("Int")) pushNodeToSelectedGroup(VariableNode.int);
				// ui.button("Array");
				if(ui.button("Boolean")) pushNodeToSelectedGroup(VariableNode.boolean);
			}
			if(ui.panel(Id.handle(), "Std")){
				if(ui.button("Print")) pushNodeToSelectedGroup(StdNode.print);
				if(ui.button("Parse Int")) pushNodeToSelectedGroup(StdNode.parseInt);
				if(ui.button("Parse Float")) pushNodeToSelectedGroup(StdNode.parseFloat);
				if(ui.button("Float To Int")) pushNodeToSelectedGroup(StdNode.floatToInt);
			}
			if(ui.panel(Id.handle(), "Math")){
				if(ui.button("Maths")) pushNodeToSelectedGroup(MathNode.maths);
				if(ui.button("Rad to Deg")) pushNodeToSelectedGroup(MathNode.radtodeg);
				if(ui.button("Deg to Rad")) pushNodeToSelectedGroup(MathNode.degtorad);
				if(ui.button("Random (Int)")) pushNodeToSelectedGroup(MathNode.randi);
				if(ui.button("Random (Float)")) pushNodeToSelectedGroup(MathNode.randf);
			}
			for (value in paddy.Plugin.plugins) if (value.nodeMenuUI != null) value.nodeMenuUI(ui);
		}
	}

	public static function getNodesArrayNames() {
		var names = [];
		for (nodes in nodesArray) names.push(nodes.name);
		return names;
	}

	public static function pushNodeToSelectedGroup(tnode:TNode) {
		selectedNode.nodeCanvas.nodes.push(NodeCreator.createNode(tnode, selectedNode.nodes, selectedNode.nodeCanvas));
	}

}