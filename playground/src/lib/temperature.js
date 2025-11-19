export function convertTemperature(value, from, to) {
  if (from === "C" && to === "F") {
    return value * (9 / 5) + 32;
  }
  if (from === "F" && to === "C") {
    return (value - 32) * (5 / 9);
  }
  throw new Error(`Unsupported temperature conversion: ${from} to ${to}`);
}
