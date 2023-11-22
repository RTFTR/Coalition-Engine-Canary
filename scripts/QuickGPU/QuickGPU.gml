/*----------------------------
	QuickGPU. A faster method on drawing in gpu blendmodes wth the very basic components.
	- By Eden's Studio (C) 2023, MIT License.
	Crediting is optional but don't remove this 5 line comment plz :P
----------------------------*/
#region Macro
#macro QUICKGPU_VERSION "v 0.0a"
#endregion
show_debug_message("QuickGPU: Welcome to QuickGPU" + QUICKGPU_VERSION);

#region Quick Functions
function QuickGPU()
{
	return new GPU_DRAW();
}
/**
	Adds a gpu_set_blendmode() function for global drawing, returns current size of the global gpu function array for removal
	@param {Asset.GMObject}		object			The object of the draw event to execute
	@param {Constant.EventType}	event			The draw event to execute in
	@param {real}				blendmode		The blendmode to draw
	@param {function}			function		The drawing function
	@param {real}				order			Whether the order of drawing is taken into account (Default 0, which means false)
*/
function AddGPU(obj = oGPUDrawer, event = event_type, blendmode, func, order = 0)
{
	return oGPUDrawer.GPU.Add(obj, event, blendmode, func, order);
}
/**
	Adds a gpu_set_blendmode_ext() function for global drawing, returns current size of the global gpu function array for removal
	@param {Asset.GMObject}		object			The object of the draw event to execute
	@param {Constant.EventType}	event			The draw event to execute in
	@param {real}				blendmode_src	Source blendmode factor
	@param {real}				blendmode_dest	Destination blendmode factor
	@param {function}			function		The drawing function
	@param {real}				order			Whether the order of drawing is taken into account (Default 0, which means false)
*/
function AddGPUExt(obj = oGPUDrawer, event = event_type, blendmode_src, blendmode_dest, func, order = 0)
{
	return oGPUDrawer.GPU.AddExt(obj, event, blendmode_src, blendmode_dest, func, order);
}
///Removes the draw function from the global GPU array
///@param {real} ID			The ID of the function to remove (Get from .Add*())
function GPURemove(ID)
{
	with oGPUDrawer array_delete(ID[0], ID[1], 1);
}
#endregion

#region Internal functions
///feather ignore all
//Make sure the global GPU drawer exists
room_instance_add(room_first, 0, 0, oGPUDrawer);
function __GPU_EVENT_BASE() constructor
{
	//For refrence
	static __GPU_Blendmode = [bm_normal, bm_add, bm_max, bm_subtract];
	static __GPU_BlendmodeExt =
	[
		bm_zero, bm_one, bm_src_color, bm_inv_src_color, bm_src_alpha, bm_inv_src_alpha,
		bm_dest_alpha, bm_inv_dest_alpha, bm_dest_colour, bm_inv_dest_colour, bm_src_alpha_sat
	];
	//array[blendmode[object, event, function]]
	__GPU_DrawFunction = array_create_2d(4, 0);
	__GPU_DrawFunctionSpecific = array_create_2d(4, 0);
	//array[blendmode_src[blendmode_dest[object, event, function]]]
	__GPU_DrawFunctionExt = array_create_3d(11, 11, 0);
	__GPU_DrawFunctionExtSpecific = array_create_3d(11, 11, 0);
	static __GPU_ArraySortFunction = function(arr1, arr2) {
		return arr2 > arr1;
	}
}

function GPU_DRAW() : __GPU_EVENT_BASE() constructor
{
	/**
		Adds a gpu_set_blendmode() function for global drawing, returns current size of the global gpu function array for removal
		@param {Asset.GMObject}		object			The object of the draw event to execute
		@param {Constant.EventType}	event			The draw event to execute in
		@param {real}				blendmode		The blendmode to draw
		@param {function}			function		The drawing function
		@param {real}				order			Whether the order of drawing is taken into account (Default 0, which means false)
	*/
	static Add = function(obj = oGPUDrawer, event = event_type, blendmode, func, order = 0)
	{
		//Process order of gpu drawing functions
		var TargetArray = order == 0 ? __GPU_DrawFunction : __GPU_DrawFunctionSpecific;
		TargetArray = TargetArray[blendmode];
		array_push(TargetArray, [obj, func, event]);
		array_sort(TargetArray, __GPU_ArraySortFunction);
		return [TargetArray, array_length(TargetArray) - 1];
	}
	/**
		Adds a gpu_set_blendmode_ext() function for global drawing, returns current size of the global gpu function array for removal
		@param {Asset.GMObject}		object			The object of the draw event to execute
		@param {Constant.EventType}	event			The draw event to execute in
		@param {real}				blendmode_src	Source blendmode factor
		@param {real}				blendmode_dest	Destination blendmode factor
		@param {function}			function		The drawing function
		@param {real}				order			Whether the order of drawing is taken into account (Default 0, which means false)
	*/
	static AddExt = function(obj = oGPUDrawer, event = event_type, blendmode_src, blendmode_dest, func, order = 0)
	{
		//Process order of gpu drawing functions
		var TargetArray = order == 0 ? __GPU_DrawFunctionExt : __GPU_DrawFunctionExtSpecific;
		TargetArray = TargetArray[blendmode_src][blendmode_dest];
		array_push(TargetArray, [obj, func, event]);
		array_sort(TargetArray, __GPU_ArraySortFunction);
		return [TargetArray, array_length(TargetArray) - 1];
	}
	///Removes the draw function from the global GPU array
	///@param {real} ID			The ID of the function to remove (Get from .Add*())
	static Remove = function(ID)
	{
		array_delete(ID[0], ID[1], 1);
	}
	///Executes the gpu_set_blendmode()
	///@param {Constant.EventType} event	The draw event to execute in
	static Execute = function(event = event_type)
	{
		//Basically I looped through all possible combinations for blendmode_ext
		//And there are 121 combinations in ext so here we are at 250 loops in total...
		var i = 0, k = 0, j = 0;
		//Execute draw event
		//Order: Normal draw function -> Ext draw function -> Normal weighted order -> Ext weighted order
		repeat 4 //Normal
		{
			var func = __GPU_DrawFunction[i], n = array_length(func), j = 0;
			//Empty draw functions -> try next
			if n == 0
			{
				++i;
				continue;
			}
			gpu_set_blendmode(i);
			//Execute event
			repeat n
			{
				//Don't draw if the current event is not targetted event
				if func[j][2] == event
					with func[j][0] func[j++][1]();
			}
			++i;
		}
		i = 0;
		repeat 11 //Ext - src
		{
			k = 0;
			repeat 11 //dest
			{
				var func = __GPU_DrawFunctionExt[i][k], n = array_length(func), j = 0;
				//Empty draw functions -> try next
				if n == 0
				{
					++k;
					continue;
				}
				gpu_set_blendmode_ext(i, k);
				//Execute event
				repeat n
				{
					//Don't draw if the current event is not targetted event
				if func[j][2] == event
					with func[j][0] func[j++][1]();
				}
				++k;
			}
			++i;
		}
		i = 0;
		repeat 4 //Normal weighted
		{
			var curOrder = 1, j = 0, func = __GPU_DrawFunctionSpecific[i], n = array_length(func);
			//Empty draw functions -> try next
			if n == 0
			{
				++i;
				continue;
			}
			gpu_set_blendmode(i);
			//Execute event
			repeat n
			{
				//Don't draw if the current event is not targetted event
				if func[j][2] == event
				{
					//Don't draw if the current drawing order is not given order
					if func[j][3] != curOrder continue;
					with func[j][0] func[j++][1]();
					++curOrder;
				}
			}
			++i;
		}
		i = 0;
		repeat 11 //Ext weighted - src
		{
			k = 0;
			repeat 11 //dest
			{
				var func = __GPU_DrawFunctionExtSpecific[i][k], n = array_length(func), j = 0;
				//Empty draw functions -> try next
				if n == 0
				{
					++k;
					continue;
				}
				gpu_set_blendmode_ext(i, k);
				//Execute event
				repeat n
				{
					//Don't draw if the current event is not targetted event
					if func[j][2] == event
					{
						//Don't draw if the current drawing order is not given order
						if func[j][3] != curOrder continue;
						with func[j][0] func[j++][1]();
					}
					++curOrder;
				}
				++k;
			}
			++i;
		}
		gpu_set_blendmode(bm_normal);
	}
}
#endregion