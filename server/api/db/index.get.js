export default eventHandler(async (event) => {
  return hubKV().get('db');
})
