<script setup lang="ts">
useSeoMeta({
  title: 'NuxtHub Starter',
  description: 'A Nuxt template to build your full-stack application on the edge.'
})

const db = ref(null);


  const t = Date.now()
  db.value = await $fetch('/api/db/en');
  console.log( 'Fetch DB from KV:', Date.now() - t )


const nestId = generateNestId( 35 );
</script>

<template>
  <NuxtPage />
  <hr>
  {{ nestId }}
  <hr>
  {{ db ? Object.keys( db ).length : null }}
  <hr>
</template>
