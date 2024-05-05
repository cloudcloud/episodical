<template>
  <v-container>
    <v-row>
      <v-col cols="6">
        <ConfigFilesystems />
      </v-col>

      <v-col cols="6">
        <ConfigIntegrations />
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import ConfigFilesystems from '@/components/ConfigFilesystems';
import ConfigIntegrations from '@/components/ConfigIntegrations';

export default {
  data: () => ({
  }),
  methods: {
  },
  components: {
    ConfigFilesystems,
    ConfigIntegrations,
  },
};
</script>

<style></style>
