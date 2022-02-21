const fs = require('fs');

const filePath = process.argv[2] || 'CHANGELOG.md';

fs.readFile(filePath, 'utf-8', (err, data) => {
    if (err) {
        console.error(err);
        process.exit(1);
    }

    // Replace the default header with markdown front matter for docusaurus pages
    data = `---
title: Intune Changelog
sidebar_label: Changelog
---
` + data;

    data = data.replace('# @ionic-enterprise/intune', '');

    fs.writeFile("../../website/docs/changelog.md", data, (err) => {
        if (err) {
            console.error(err);
        }
    })

})