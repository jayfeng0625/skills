// Configuration loader - currently a shallow pass-through module
// Each caller must know all the config details

const fs = require('fs');
const path = require('path');

function readConfigFile(filePath) {
  const raw = fs.readFileSync(filePath, 'utf8');
  return JSON.parse(raw);
}

function getStringValue(config, key) {
  if (!config[key]) throw new Error(`Missing config key: ${key}`);
  if (typeof config[key] !== 'string') throw new Error(`Config key ${key} is not a string`);
  return config[key];
}

function getNumberValue(config, key) {
  if (config[key] === undefined) throw new Error(`Missing config key: ${key}`);
  if (typeof config[key] !== 'number') throw new Error(`Config key ${key} is not a number`);
  return config[key];
}

function getBooleanValue(config, key) {
  if (config[key] === undefined) throw new Error(`Missing config key: ${key}`);
  if (typeof config[key] !== 'boolean') throw new Error(`Config key ${key} is not a boolean`);
  return config[key];
}

function getOptionalStringValue(config, key, defaultValue) {
  if (!config[key]) return defaultValue;
  if (typeof config[key] !== 'string') throw new Error(`Config key ${key} is not a string`);
  return config[key];
}

function getOptionalNumberValue(config, key, defaultValue) {
  if (config[key] === undefined) return defaultValue;
  if (typeof config[key] !== 'number') throw new Error(`Config key ${key} is not a number`);
  return config[key];
}

function validateRequiredKeys(config, requiredKeys) {
  for (const key of requiredKeys) {
    if (config[key] === undefined) {
      throw new Error(`Config validation failed: missing required key '${key}'`);
    }
  }
}

module.exports = {
  readConfigFile,
  getStringValue,
  getNumberValue,
  getBooleanValue,
  getOptionalStringValue,
  getOptionalNumberValue,
  validateRequiredKeys,
};
