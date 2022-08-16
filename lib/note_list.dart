class NoteExample {
  String title;
  String body;
  String date;

  NoteExample(
      {this.title = "untitled", required this.body, required this.date});
}

var NotesExample = [
  NoteExample(
      // title: "Assalam",
      body:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum ut nulla ullamcorper, tempor tellus nec, dignissim dolor. Donec lacus turpis, posuere quis eleifend non, rutrum sit amet odio. Ut et enim lectus. Fusce laoreet tincidunt augue nec volutpat. Vestibulum ut blandit libero. ",
      date: "July 17, 2022"),
  NoteExample(
      title: "Note 2",
      body:
          "In hac habitasse platea dictumst. Nunc semper nunc vitae fermentum tempus. Nunc mollis gravida lacus, quis finibus mi porttitor ac. Vivamus pharetra, metus a pretium scelerisque, sem nisi pulvinar velit, ac vehicula elit sapien eu lectus. Praesent interdum consequat accumsan. Curabitur fringilla ac lacus vitae egestas. Integer auctor magna a mi auctor, quis tempor ex tempus. Aliquam id augue sodales urna imperdiet porttitor. Nullam quis turpis diam. Curabitur nec lectus sed elit sagittis feugiat. Donec nibh ex, vehicula et faucibus eget, tristique a dolor. Vivamus sagittis enim sed erat fringilla, at sodales erat euismod. Donec nec felis pretium, dignissim mi quis, egestas nisi.",
      date: "November 12, 2022"),
  NoteExample(
      title: "Note 3",
      body: "Maecenas porta tellus tellus, ut venenatis mi imperdiet in",
      date: "Jun 17, 2021"),
  NoteExample(
      title: "Note 4",
      body:
          "Nullam tempor dignissim odio, vitae vehicula orci ornare nec. Ut commodo nisi et lectus iaculis, nec rutrum magna dapibus. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Nulla consequat viverra sapien a varius. Pellentesque interdum, nisi tempus volutpat vehicula, urna nisi semper lorem, eu rhoncus est sapien ac magna. Aliquam orci diam, vulputate euismod magna vitae, porttitor iaculis nisi.",
      date: "May 25, 2023")
];
