if (surface_exists(final_surface) && surface_exists(surf))
{
	surface_set_target(final_surface)
	shader_set(shd_gaussian_horizontal)
	shader_set_uniform_f(uni_resolution_hoz, var_resolution_x, var_resolution_y)
	shader_set_uniform_f(uni_blur_amount_hoz, var_blur_amount)
	draw_surface(surf, 0, 0)
	shader_reset()
	surface_reset_target()
	shader_set(shd_gaussian_vertical)
	shader_set_uniform_f(uni_resolution_vert, var_resolution_x, var_resolution_y)
	shader_set_uniform_f(uni_blur_amount_vert, var_blur_amount)
	draw_surface(final_surface, 0, 0)
	shader_reset()
}
if var_blur_amount <= 0
instance_destroy();

