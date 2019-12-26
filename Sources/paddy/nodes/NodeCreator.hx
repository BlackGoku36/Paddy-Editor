package paddy.nodes;

import haxe.Json;
import zui.Nodes;
import zui.Nodes.TNode;

class NodeCreator {

    public static function createNode(node: TNode, nodes: Nodes, nodeCanvas: TNodeCanvas):TNode {
        var node:TNode = Json.parse(Json.stringify(node));
        node.id = nodes.getNodeId(nodeCanvas.nodes);
        for (soc in node.inputs) {
            soc.id = nodes.getSocketId(nodeCanvas.nodes);
            soc.node_id = node.id;
        }
        for (soc in node.outputs) {
            soc.id = nodes.getSocketId(nodeCanvas.nodes);
            soc.node_id = node.id;
        }
        return node;
    }
}
