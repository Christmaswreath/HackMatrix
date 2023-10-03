#version 330 core
out vec4 FragColor;
in vec2 TexCoord;
flat in int BlockType;
flat in int isSelected;

uniform sampler2DArray texture1;
uniform sampler2D texture2;
uniform sampler2D texture3;
uniform bool isApp;
uniform bool appSelected;
uniform int totalBlockTypes;
uniform float time;

vec3 palette( float t ) {
  vec3 a = vec3(0.5, 0.5, 0.5);
  vec3 b = vec3(0.5, 0.5, 0.5);
  vec3 c = vec3(1.0, 1.0, 1.0);
  vec3 d = vec3(0.263,0.416,0.557);

  return a + b*cos( 6.28318*(c*t+d) );
}

//https://www.shadertoy.com/view/mtyGWy
vec4 floor( vec2 fragCoord ) {
  vec2 uv = (fragCoord * 2.0 - vec2(1,1)) / vec2(1,1);
  vec2 uv0 = uv;
  vec3 finalColor = vec3(0.0);

  for (float i = 0.0; i < 4.0; i++) {
    uv = fract(uv * 1.5) - 0.5;

    float d = length(uv) * exp(-length(uv0));

    vec3 col = palette(length(uv0) + i*.4 + time*.4);

    d = sin(d*8. + time)/8.;
    d = abs(d);

    d = pow(0.01 / d, 1.2);

    finalColor += col * d;
  }
  return vec4(finalColor, 1.0);
}

void main()
{
  if(isApp) {
    FragColor = texture(texture3, TexCoord * vec2(1,-1));
    if(!appSelected) {
      FragColor = mix(FragColor, floor(TexCoord), 0.2);
    }
  } else {
    if(BlockType == 1) {
      FragColor = floor(TexCoord);
    } else {
      FragColor = texture(texture1, vec3(TexCoord.x, TexCoord.y, BlockType));
    }
  }
  if(isSelected == 1) {
    FragColor = FragColor * vec4(2.0,2.0,2.0,1.0);
  }
}
