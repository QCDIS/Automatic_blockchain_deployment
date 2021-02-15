<template>
  <footer class="footer">
    <div class="container-fluid">
      <div class="copyright">
        © {{year}} created by
        <a href="https://www.linkedin.com/in/jardenna-mohazzab-461447122/" target="_blank" rel="noopener">Jardenna Mohazzab</a>
      </div>
    </div>
  </footer>
</template>
<script>
  export default {
    data() {
      return {
        year: new Date().getFullYear()
      }
    }
  };
</script>
<style>
</style>
