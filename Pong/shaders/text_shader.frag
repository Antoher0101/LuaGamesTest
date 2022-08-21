
vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords){
    return Texel(texture, texture_coords) * vec4(0.4275, 0.0, 0.4275, 0.3);
}