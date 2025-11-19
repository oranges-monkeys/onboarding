export function convertWeight(value, from, to) {
  if (from === "g" && to === "oz") return value / 28.3495;
  if (from === "oz" && to === "g") return value * 28.3495;
  throw new Error(`Unsupported weight conversion: ${from} to ${to}`);
}
