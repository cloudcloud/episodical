<template>
  <v-container>
    <!-- we have several areas to configure: the types of collections, each collection loaded, sub-page for collection specific config, etc -->
    <!-- types we could have are "episodic" that could have a data provider of "thetvdb.com" for instance, "artist" that could use musicbrainz.org, "document" that could use goodreads (maybe?), etc -->
    <v-row>
      <v-col cols="6">
        <v-card shaped title="Episodic">
          <template v-slot:append>
            <v-btn icon="mdi-plus" x-small @click="newEpisodic()"></v-btn>
          </template>
        </v-card>
      </v-col>

      <v-col cols="6">
        <v-card shaped title="Artistic">
          <template v-slot:append>
            <v-btn icon="mdi-plus" x-small @click="newArtistic()"></v-btn>
          </template>
        </v-card>
      </v-col>

      <v-col cols="6">
        <v-card shaped title="Document">
          <template v-slot:append>
            <v-btn icon="mdi-plus" x-small @click="newDocument()"></v-btn>
          </template>
        </v-card>
      </v-col>

      <v-col cols="6">
        <v-card shaped title="Integrations">
          <template v-slot:append>
            <v-btn icon="mdi-plus" x-small @click="newIntegration()"></v-btn>
          </template>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
export default {
  data: () => ({
  }),
  methods: {
    newArtistic() {
    },
    newDocument() {
    },
    newEpisodic() {
    },
    newIntegration() {
    },
  },
};
</script>

<style></style>
