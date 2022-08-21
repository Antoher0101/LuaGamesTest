vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
{
    vec4 texturecolor = Texel(tex, texture_coords);
    return texturecolor;// * vec4(1.0,1.0,0.0,1.0);
}