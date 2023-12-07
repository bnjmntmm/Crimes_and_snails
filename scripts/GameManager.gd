extends Node


enum State{
	PLAY,
	BUILD,
	DESTROY,
	POV_MODE
}
var current_state=State.PLAY

var food:=0
var wood:=0
var planks:=0
var snails:=0
var happiness:=0

var population:=0
var max_population
var available_population
var citizen: PackedScene

