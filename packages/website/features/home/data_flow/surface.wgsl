fn surfaceScale(position: vec3f, progress: f32, time: f32) -> f32 {
  let phase = position * vec3f(1.8, 2.2, 1.7) + time * vec3f(0.8, -0.6, 0.55);
  let amplitude = 0.1 + progress * 0.08;
  return 1.0 + amplitude * sin(phase.x) * sin(phase.y) * sin(phase.z);
}

export fn flowPosition(position: vec3f, progress: f32, time: f32) -> vec3f {
  return position * surfaceScale(position, progress, time);
}

export fn flowNormal(position: vec3f, normal: vec3f, progress: f32, time: f32) -> vec3f {
  let phase = position * vec3f(1.8, 2.2, 1.7) + time * vec3f(0.8, -0.6, 0.55);
  let amplitude = 0.1 + progress * 0.08;
  let gradient = amplitude * vec3f(
    1.8 * cos(phase.x) * sin(phase.y) * sin(phase.z),
    2.2 * sin(phase.x) * cos(phase.y) * sin(phase.z),
    1.7 * sin(phase.x) * sin(phase.y) * cos(phase.z)
  );
  let scale = surfaceScale(position, progress, time);
  return normalize(normal - gradient * dot(position, normal) / (scale + dot(position, gradient)));
}

export fn flowColor(position: vec3f, progress: f32) -> vec3f {
  let front = smoothstep(-0.18, 0.18, position.y + 1.5 - progress * 3.0);
  return mix(vec3f(0.34, 0.28, 0.18), vec3f(0.51, 0.43, 0.3), front);
}
