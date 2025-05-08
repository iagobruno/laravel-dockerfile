import './bootstrap';
import { differenceInSeconds, endOfMinute } from 'date-fns';

Echo.channel(`logs`)
  .listenToAll(console.log.bind(null, 'Web socket event =>'))
  .listen('LogCreated', prependLog)
  .listen('LogUpdated', updateLog);

const logs = document.querySelector('ol')

function prependLog({ html }) {
  const log = parseHTML(html)
  log.classList.add('highlight')
  logs.prepend(log)
}

function updateLog({ html, json }) {
  const newContent = parseHTML(html).innerHTML
  logs.querySelector('#log-' + json.id).innerHTML = newContent
}

function parseHTML(html) {
    var t = document.createElement('template');
    t.innerHTML = html;
    return t.content.firstChild;
}

function calcEstimatedTimeToNextUpdate() {
  const now = new Date();
  const nextUpdateIn = endOfMinute(now);
  const estimatedTime = differenceInSeconds(nextUpdateIn, now);
  document.getElementById('estimate').innerText = `Próxima atualização em ${estimatedTime} segundos...`;
}

calcEstimatedTimeToNextUpdate();
setInterval(calcEstimatedTimeToNextUpdate, 1000);
