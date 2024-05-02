<template>
  <v-container>
    <v-row>
      <v-col cols="6">
        <ConfigCard title="Add File System" type="filesystems" />
      </v-col>

      <v-col cols="6">
        <ConfigCard title="Add Integration" type="integrations" />
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import ConfigCard from '@/components/ConfigCard';

export default {
  data: () => ({
  }),
  methods: {
  },
  components: {
    ConfigCard,
  },
};
</script>

<style></style>
