package paddy.nodes;

import kha.Color;
import zui.Nodes.TNode;

class StdNode {

	public static var parseInt: TNode = {
		id: 0,
		name: "Parse Int",
		type: "ParseIntNode",
		x: 200,
		y: 200,
		color: -4962746,
		inputs: [
			{
				id: 0,
				node_id: 0,
				name: "String",
				type: "STRING",
				color: Color.fromBytes(180, 180, 180),
				default_value: ""
			}
		],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name: "Int",
				type: "VALUE",
				color: Color.fromBytes(180, 180, 180),
				default_value: ""
			}
		],
		buttons: []
	}

	public static var parseFloat: TNode = {
		id: 0,
		name: "Parse Float",
		type: "ParseFloatNode",
		x: 200,
		y: 200,
		color: -4962746,
		inputs: [
			{
				id: 0,
				node_id: 0,
				name: "String",
				type: "STRING",
				color: Color.fromBytes(180, 180, 180),
				default_value: ""
			}
		],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name: "Float",
				type: "VALUE",
				color: Color.fromBytes(180, 180, 180),
				default_value: ""
			}
		],
		buttons: []
	}

	public static var floatToInt: TNode = {
		id: 0,
		name: "Float to Int",
		type: "FloatToIntNode",
		x: 200,
		y: 200,
		color: -4962746,
		inputs: [
			{
				id: 0,
				node_id: 0,
				name: "Float",
				type: "VALUE",
				color: Color.fromBytes(180, 180, 180),
				default_value: ""
			}
		],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name: "Int",
				type: "VALUE",
				color: Color.fromBytes(180, 180, 180),
				default_value: ""
			}
		],
		buttons: []
	}

	public static var print: TNode = {
		id: 0,
		name: "Print",
		type: "PrintNode",
		x: 200,
		y: 200,
		color: -4962746,
		inputs: [
			{
				id: 0,
				node_id: 0,
				name: "In",
				type: "ACTION",
				color: 0xffaa4444,
				default_value: ""
			},
			{
				id: 1,
				node_id: 0,
				name: "Value",
				type: "STRING",
				color: 0xff44aa44,
				default_value: ""
			}
		],
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
		buttons: []
	}

}
