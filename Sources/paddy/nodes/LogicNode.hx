package paddy.nodes;

import kha.Color;
import zui.Nodes.TNode;

class LogicNode {

	public static var gate: TNode = {
		id: 0,
		name: "Gate",
		type: "GateNode",
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
				default_value: 0.0
			},
			{
				id: 1,
				node_id: 0,
				name: "Bool",
				type: "BOOLEAN",
				color: -10822566,
				default_value: 0.0
			},
			{
				id: 2,
				node_id: 0,
				name: "Bool",
				type: "BOOLEAN",
				color: -10822566,
				default_value: 0.0
			}
		],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name: "True",
				type: "BOOL",
				color: -10822566,
				default_value: 0.0
			},
			{
				id: 1,
				node_id: 0,
				name: "False",
				type: "BOOL",
				color: -10822566,
				default_value: 0.0
			}
		],
		buttons: [
			{
				name: "operations",
				type: "ENUM",
				data: [
					"OR",
					"AND",
					"Equal",
					"Less", "Less Equal",
					"Greater", "Greater Equal"
				]
			}
		]
	}
	public static var branch: TNode = {
		id: 0,
		name: "Branch",
		type: "BranchNode",
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
				default_value: 0.0
			},
			{
				id: 1,
				node_id: 0,
				name: "Bool",
				type: "BOOLEAN",
				color: -10822566,
				default_value: 0.0
			}
		],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name: "Out",
				type: "ACTION",
				color: 0xffaa4444,
				default_value: 0.0
			},
			{
				id: 0,
				node_id: 0,
				name: "True",
				type: "BOOL",
				color: -10822566,
				default_value: 0.0
			},
			{
				id: 1,
				node_id: 0,
				name: "False",
				type: "BOOL",
				color: -10822566,
				default_value: 0.0
			}
		],
		buttons: []
	}
	public static var isFalse: TNode = {
		id: 0,
		name: "Is False",
		type: "IsFalseNode",
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
				default_value: 0.0
			},
			{
				id: 1,
				node_id: 0,
				name: "Bool",
				type: "BOOLEAN",
				color: -10822566,
				default_value: 0.0
			}
		],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name: "Out",
				type: "ACTION",
				color: 0xffaa4444,
				default_value: 0.0
			}
		],
		buttons: []
	}
	public static var isTrue: TNode = {
		id: 0,
		name: "Is True",
		type: "IsTrueNode",
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
				default_value: 0.0
			},
			{
				id: 1,
				node_id: 0,
				name: "Bool",
				type: "BOOLEAN",
				color: -10822566,
				default_value: 0.0
			}
		],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name: "Out",
				type: "ACTION",
				color: 0xffaa4444,
				default_value: 0.0
			}
		],
		buttons: []
	}
	public static var whileN: TNode = {
		id: 0,
		name: "While",
		type: "WhileNode",
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
				default_value: 0.0
			},
			{
				id: 1,
				node_id: 0,
				name: "Condition",
				type: "BOOLEAN",
				color: -10822566,
				default_value: 0.0
			}
		],
		outputs: [
			{
				id: 0,
				node_id: 0,
				name: "Loop",
				type: "ACTION",
				color: 0xffaa4444,
				default_value: 0.0
			},
			{
				id: 0,
				node_id: 0,
				name: "Done",
				type: "ACTION",
				color: 0xffaa4444,
				default_value: 0.0
			}
		],
		buttons: []
	}
}
