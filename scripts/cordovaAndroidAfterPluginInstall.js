const fs = require('fs');
const util = require('util');
const path = require('path');
const stat = util.promisify(fs.stat);
const readFile = util.promisify(fs.readFile);
const writeFile = util.promisify(fs.writeFile);

module.exports = async function (ctx) {
  if (!ctx.opts.cordova.platforms.includes('android')) return;

  const platformRoot = path.join(ctx.opts.projectRoot, 'platforms/android');

  const buildGradle = path.join(platformRoot, 'build.gradle');

  const contents = await readFile(buildGradle, 'utf-8');

  const targetString = '// in the individual module build.gradle files';

  const index = contents.indexOf(targetString);

  if (index < 0) {
    console.error(
      'Unable to find place to insert required Intune gradle plugin into build.gradle.',
    );
    return;
  }

  const lines = `
        classpath "org.javassist:javassist:3.27.0-GA"
        classpath files("./app/src/main/libs/com.microsoft.intune.mam.build.jar")
  `;

  const newFile = contents.slice(0, index) + lines + contents.slice(index);

  await writeFile(buildGradle, newFile);

  console.log('build.gradle updated to use Intune Gradle plugin');
};
