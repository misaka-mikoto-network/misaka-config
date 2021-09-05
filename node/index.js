const ls = require('ls')
const fs = require('fs')
const cron = require('node-cron')
const config = require('./config/config.json')
const list = config.mirroringPackages

cron.schedule('*/1 * * * *', () => {
  let syncing = []
  for (let i = 0, cnt = list.length; i < cnt; i++) {
    let fileList = ls(`${config.mirroringDir}/${list[i]}/*`, /Archive-Update-in-Progress-mirror.misakamikoto.network/)
    if (Object.keys(fileList).length !== 0) {
      syncing.push(list[i])
    }
  }

  fs.readFile(`${config.statusJsonLocation}/status.json`, 'utf8', (err, data) => {
    let statusJson = JSON.parse(data)
    for (let i = 0, cnt = statusJson.status.length; i < cnt; i++) {
      if (syncing.includes(statusJson.status[i].name)) {
        statusJson.status[i].status = 0
      } else {
        statusJson.status[i].status = 1
      }
    }
    statusJson.datetime = Date().toLocaleString()
    fs.writeFileSync(`${config.statusJsonLocation}/status.json`, JSON.stringify(statusJson))
  })
})