<template>
  <v-chip
    :text="text"
    variant="outlined"
    density="comfortable"
    :color="color()" />
</template>

<script>
export default {
  data: () => ({
  }),
  props: ["text", "gradient"],
  methods: {
    color() {
      switch (this.gradient) {
        case 0:
          return "red-darken-4";
        case 1:
          return "red-darken-2";
        case 2:
          return "red-lighten-1";
        case 3:
          return "red-lighten-3";
        case 4:
          return "pink-lighten-2";
        case 5:
          return "teal-lighten-2";
        case 6:
          return "teal-darken-1";
        case 7:
          return "teal-darken-3";
        case 8:
          return "green-lighten-2";
        case 9:
          return "green-darken-1";
        case 10:
          return "green";
      };
    },
  },
};
</script>

<style scoped>
</style>
