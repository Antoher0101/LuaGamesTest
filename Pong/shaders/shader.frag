extern float iTime;

vec2 crt(vec2 coord, float bend)
{
	// put in symmetrical coords
	coord = (coord - 0.5) * 2.0;

	coord *= 1.1;	

	// deform coords
	coord.x *= 1.0 + pow((abs(coord.y) / bend), 2.0);
	coord.y *= 1.0 + pow((abs(coord.x) / bend), 2.0);

	// transform back to 0.0 - 1.0 space
	coord  = (coord / 2.0) + 0.5;

	return coord;
}

vec3 sampleSplit(Image tex, vec2 coord)
{
	vec3 frag;
	frag.r = Texel(tex, vec2(coord.x - 0.01 * sin(iTime), coord.y)).r;
	frag.g = Texel(tex, vec2(coord.x, coord.y)).g;
	frag.b = Texel(tex, vec2(coord.x + 0.01 * sin(iTime), coord.y)).b;
	return frag;
}

vec3 scanline(vec2 coord, vec3 screen, float time)
{
	screen.rgb -= sin((coord.y + (time * 29.0))) * 0.02;
	return screen;
}

vec4 effect( vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords ){
	float time = iTime;
	vec2 crtCoords = crt(texture_coords, 3.2);
	if (crtCoords.x < 0.0 || crtCoords.x > 1.0 || crtCoords.y < 0.0 || crtCoords.y > 1.0)
		discard;

	vec4 texture = vec4(sampleSplit(tex,crtCoords),1.0);
	

	return  vec4(scanline(screen_coords, texture.rgb, iTime), 0.5);
}