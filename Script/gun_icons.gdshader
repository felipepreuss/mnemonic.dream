shader_type canvas_item;

uniform vec4 outline_color : source_color = vec4(1.0, 1.0, 1.0, 1.0); // White outline
uniform float outline_width : hint_range(0.0, 10.0, 0.1) = 2.0;

void fragment() {
    vec4 original_color = texture(TEXTURE, UV);
    vec4 final_color = original_color;

    // Only process if the original pixel is not fully transparent
    if (original_color.a > 0.0) {
        final_color = original_color;
    } else {
        // Check surrounding pixels for outline
        float max_dist = outline_width * TEXTURE_PIXEL_SIZE.x;
        float closest_outline_dist = max_dist + 1.0;

        for (float x = -outline_width; x <= outline_width; x += 1.0) {
            for (float y = -outline_width; y <= outline_width; y += 1.0) {
                vec2 offset = vec2(x, y) * TEXTURE_PIXEL_SIZE;
                vec4 neighbor_color = texture(TEXTURE, UV + offset);

                if (neighbor_color.a > 0.0) {
                    float dist = length(offset);
                    if (dist < closest_outline_dist) {
                        closest_outline_dist = dist;
                    }
                }
            }
        }

        if (closest_outline_dist <= max_dist) {
            float alpha = 1.0 - (closest_outline_dist / max_dist);
            final_color = mix(vec4(0.0), outline_color, alpha); // Mix with outline color
        } else {
            final_color = vec4(0.0); // Transparent if no outline
        }
    }
    COLOR = final_color;
}