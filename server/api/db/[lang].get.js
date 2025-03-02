export default eventHandler(async (event) => {
  const { lang } = event.context.params || {}
  event.headers.append('content-type', 'text');
  return hubKV().get(`db:${lang}`);
})
