<template>
  <v-container>
    <v-row>
      <v-col cols="12">

        <v-card shaped>
          <v-card-title>
            <v-row>
              <v-col cols="6" align="left">
                Latest Happenings
              </v-col>
              <v-col cols="6">
                <v-text-field v-model="search" clearable variant="underlined" placeholder="Search"></v-text-field>
              </v-col>
            </v-row>
          </v-card-title>

          <v-data-table :headers="headers" :items="historical" :search="search" class="elevation-1" hover height="100%">
          </v-data-table>
        </v-card>

      </v-col>
    </v-row>
  </v-container>
</template>

<script>
export default {
  data: () => ({
    headers: [
      {title: 'Collection', align: 'left', key: 'collection'},
      {title: 'Action', align: 'left', key: 'action'},
      {title: 'Type', align: 'left', key: 'type'},
      {title: 'Date', align: 'left', key: 'date'},
    ],
    historical: [],
    search: '',
  }),
  props: [],
};
</script>

<style></style>
